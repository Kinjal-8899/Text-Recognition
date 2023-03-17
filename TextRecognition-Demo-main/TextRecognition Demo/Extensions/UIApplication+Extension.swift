//
//  UIApplication+Extension.swift
//  Scan Characters Demo
//
//  Created by Harindra Pittalia on 08/03/22.
//

import UIKit

extension UIApplication {
    private class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    class var topViewController: UIViewController? { return topViewController() }
}
