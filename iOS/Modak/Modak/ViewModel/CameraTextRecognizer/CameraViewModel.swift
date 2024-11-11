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
    @Published var isCapturing: Bool = false {
        didSet {
            if !isCapturing, let image = recentImage {
                textRecognizeHandler?(image)
            }
        }
    }
    @Published var cameraPermissionAlert = false
    @Published var isSessionStarted = false
    
    var textRecognizeHandler: ((UIImage) -> Void)?
    
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
                    self?.startSessionIfNeeded()
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
            startSessionIfNeeded()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupSession()
                        self?.startSessionIfNeeded()
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
    
    func startSessionIfNeeded() {
        if !session.isRunning && AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            DispatchQueue.global().async { [weak self] in
                self?.session.startRunning()
                DispatchQueue.main.async {
                    self?.isSessionStarted = true
                }
            }
        }
    }
    
    func stopSession() {
        if session.isRunning {
            DispatchQueue.global().async { [weak self] in
                self?.session.stopRunning()
                DispatchQueue.main.async {
                    self?.isSessionStarted = false
                }
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
