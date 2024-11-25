//
//  ViewExtension.swift
//  Modak
//
//  Created by Park Junwoo on 10/31/24.
//

import SwiftUI

extension View {
    // 화면 터치 시, 키보드 내려가게 하는 뷰 모디파이어
    func tapDismissesKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    // SwiftUI View를 UIImage로 변환
    func asUIImage(size: CGSize) -> UIImage? {
        let hostingController = UIHostingController(rootView: self)
        let view = hostingController.view
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear
        
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.drawHierarchy(in: view?.bounds ?? .zero, afterScreenUpdates: true)
        }
    }
}
