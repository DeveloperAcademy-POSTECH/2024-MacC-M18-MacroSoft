//
//  AuthorizationViewModel.swift
//  Modak
//
//  Created by kimjihee on 10/11/24.
//

import Foundation
import Photos
import SwiftUI

class AuthorizationViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var navigateToOrganizePhotoView: Bool = false

    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self.navigateToOrganizePhotoView = true
                case .denied, .restricted, .notDetermined:
                    self.showAlert = true
                @unknown default:
                    break
                }
            }
        }
    }
}
