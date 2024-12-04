//
//  UINavigationControllerExtension.swift
//  Modak
//
//  Created by Park Junwoo on 10/18/24.
//

import UIKit

// Swipe back Gesture를 위한 UINavigationController extension
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // 2가지 조건 모두 만족했을 때 뒤로가기 제스처를 활성화 시킵니다!
        return PopGestureManager.shared.isAllowPopGesture && viewControllers.count > 1
    }
}

final class PopGestureManager {
    
    // Singleton 객체 생성
    static let shared = PopGestureManager()
    private init() {}
    
    // 뒤로가기 제스처를 허용하는지 확인 변수
    private(set) var isAllowPopGesture = true
    
    // 뒤로가기 제스처를 허용하는 변수 업데이트
    func updateAllowPopGesture(_ bool: Bool) {
        isAllowPopGesture = bool
    }
}
