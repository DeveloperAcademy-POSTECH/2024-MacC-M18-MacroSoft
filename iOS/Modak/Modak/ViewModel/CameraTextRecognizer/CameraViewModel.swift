//
//  CameraViewModel.swift
//  Modak
//
//  Created by kimjihee on 10/31/24.
//


import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var session: AVCaptureSession = AVCaptureSession()
    private var subscriptions = Set<AnyCancellable>()
    
    let cameraPreview: AnyView
    
    @Published var recentImage: UIImage?
    @Published var isCapturing: Bool = false
    @Published var cameraPermissionAlert = false
    
    override init() {
        cameraPreview = AnyView(CameraGuidePreview(session: session))
        super.init()
        checkCameraPermission()
        setupBindings()
    }
    
    private func setupSession() {
        session.beginConfiguration()
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else { return }
        session.addInput(videoDeviceInput)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.queue"))
        session.addOutput(output)
        
        session.commitConfiguration()
    }
    
    private func setupBindings() {
        $isCapturing
            .sink { [weak self] isCapturing in
                if isCapturing {
                    self?.startSession()
                } else {
                    self?.stopSession()
                }
            }
            .store(in: &subscriptions)
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupSession()
                    } else {
                        self?.cameraPermissionAlert = true
                    }
                }
            }
        case .denied, .restricted:
            cameraPermissionAlert = true
        @unknown default:
            break
        }
    }
    
    func startSession() {
        if !session.isRunning && AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            DispatchQueue.global().async { [weak self] in
                self?.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        if session.isRunning {
            DispatchQueue.global().async { [weak self] in
                self?.session.stopRunning()
            }
        }
    }
    
    func capturePhoto(from sampleBuffer: CMSampleBuffer) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right) // 사진을 올바른 방향으로 설정
            DispatchQueue.main.async { [weak self] in
                self?.recentImage = image
                self?.isCapturing = false  // 캡처 완료 후 카메라 정지
                self?.recognizeText(from: image)
            }
        }
    }
    
    func recognizeText(from image: UIImage) {
        Task {
            let textRecognizer = TextRecognizer()
            do {
                let recognizedText = try await textRecognizer.recognizeText(in: image)
                print("Recognized Text: \(recognizedText)")
                
                // recognizedText를 줄 단위로 나눔
                let lines = recognizedText.components(separatedBy: .newlines)
                
                // "모닥불 참여하기를 눌러 하단 이정표를 스캔해 주세요."를 찾은 후, 다음 줄을 roomName으로 설정
                if let startIndex = lines.firstIndex(where: { $0.contains("모닥불 참여하기를 눌러 하단 이정표를 스캔해 주세요.") }),
                   startIndex + 1 < lines.count {
                    
                    var roomName = lines[startIndex + 1]
                    
                    // "까지" 또는 " 까지"가 포함되어 있으면 이를 제거
                    if let range = roomName.range(of: "까지") {
                        roomName.removeSubrange(range)
                    } else if let range = roomName.range(of: " 까지") {
                        roomName.removeSubrange(range)
                    }
                    
                    print("Room Name: \(roomName)")
                }
                
                // "km 남음" 또는 " km 남음"이 포함된 줄에서 점을 제외한 숫자만 추출하여 roomPassword로 설정
                if let distanceTextLine = lines.first(where: { $0.contains("km 남음") || $0.contains(" km 남음") }) {
                    
                    // "km 남음" 또는 " km 남음"을 제거
                    var distanceText = distanceTextLine.replacingOccurrences(of: "km 남음", with: "")
                    distanceText = distanceText.replacingOccurrences(of: " km 남음", with: "")
                    
                    // 숫자만 추출하여 roomPassword로 설정
                    let roomPassword = distanceText.compactMap { $0.isNumber ? String($0) : nil }.joined()
                    print("Room Password: \(roomPassword)")
                }
                
            } catch {
                print("Text recognition failed: \(error)")
            }
        }
    }

    
    // 카메라가 새로운 프레임을 캡처할 때마다 자동으로 호출됨
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 여기에서 특정 조건이 만족되면 자동으로 capturePhoto()를 호출합니다.
        if isCapturing {
            capturePhoto(from: sampleBuffer)
            
        }
    }
}
