//
//  UIView.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    private struct AssociatedKey {
        static var gradient: String = "gradient"
    }
    public var gradient: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.gradient) as? CAGradientLayer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.gradient, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func gradientColor(_ fromColor: UIColor, to color: UIColor) {
        if gradient != nil {
            gradient?.removeFromSuperlayer()
        }
        gradient = CAGradientLayer()
        gradient?.startPoint = .init(x: 0, y: 0)
        gradient?.endPoint = .init(x: 1, y: 0)
        gradient?.locations = [0.0, 1.0]
        gradient?.frame = bounds
        gradient?.colors = [fromColor.cgColor, color.cgColor]
        layer.insertSublayer(gradient!, at: 0)
    }

    func setShadow() {
        self.setShadow(sColor: .hex("C8C8C8"), offset: .init(width: 0, height: 0), opacity: 0.2, radius: 3)
    }

    func setShadow(sColor: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        layer.shadowColor = sColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }

    func managerController() -> UIViewController? {
        var responder = self as UIResponder
        while let next = responder.next {
            responder = next
            if next.isKind(of: UIViewController.self) {
                if next.isKind(of: UINavigationController.self) {
                    let navc = next as? UINavigationController
                    responder = (navc?.topViewController)!
                    break
                }
                if next.isKind(of: UITabBarController.self) {
                    let tab = next as? UITabBarController
                    responder = (tab?.selectedViewController)!
                    break
                }

                let vc = next as? UIViewController
                let parent = vc?.parent
                if parent != nil {
                    if  parent!.isKind(of: UINavigationController.self) ||
                        parent!.isKind(of: UITabBarController.self) ||
                        parent!.isKind(of: UIPageViewController.self) ||
                        parent!.isKind(of: UISplitViewController.self) {
                        break
                    }
                } else {
                    break
                }
            }
        }
        return responder.isKind(of: UIViewController.self) ? responder as? UIViewController : nil
    }

    func show(message: String) {
        self.makeToast(message, duration: 2, position: .center)
    }
}
