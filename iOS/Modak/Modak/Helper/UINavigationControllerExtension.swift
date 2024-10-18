//
//  UINavigationControllerExtension.swift
//  Modak
//
//  Created by Park Junwoo on 10/18/24.
//

import UIKit

// Swipe back Gesture를 위한 UINavigationController extension
extension UINavigationController : @retroactive UINavigationControllerDelegate, @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    // Navigation Stack에 쌓인 뷰가 1개를 초과해야 제스처가 동작 하도록 적용
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return viewControllers.count > 1
    }
}
