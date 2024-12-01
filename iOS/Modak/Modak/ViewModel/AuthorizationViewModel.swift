//
//  AuthorizationViewModel.swift
//  Modak
//
//  Created by kimjihee on 10/11/24.
//

import SwiftUI
import Photos

class AuthorizationViewModel: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    @Published var showAlert: Bool = false
    @Published var navigateToOrganizePhotoView: Bool = false
    @Published var shouldShowLimitedPicker: Bool = true // 제한 접근일 때 Picker를 강제로 표시할지 여부
    
    override init() {
        super.init()
        // 사진 라이브러리 변경 감지 등록
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        // 사진 라이브러리 변경 감지 해제
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.navigateToOrganizePhotoView = true
                case .limited:
                    if self.shouldShowLimitedPicker {
                        self.showLimitedPhotoPicker()
                    } else {
                        self.navigateToOrganizePhotoView = true
                    }
                case .denied, .restricted, .notDetermined :
                    self.showAlert = true
                @unknown default:
                    break
                }
            }
        }
    }
    
    func showLimitedPhotoPicker() {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            return
        }
        
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: rootVC)
        self.shouldShowLimitedPicker = false // Picker를 보여준 후에는 다시 표시하지 않도록 설정
    }
    
    // 사진 라이브러리 변경 감지 핸들러
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.navigateToOrganizePhotoView = true
        }
    }

}
