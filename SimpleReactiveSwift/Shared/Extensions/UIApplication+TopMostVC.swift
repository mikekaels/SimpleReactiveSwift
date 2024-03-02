//
//  UIApplication+TopMostVC.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//


import UIKit

extension UIApplication {
	internal static func topMostVC() -> UIViewController? {
		return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.topMostViewController()
	}
	
	internal static func topMostTabBarViewController() -> UIViewController? {
		return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.topMostTabBarViewController()
	}
}

extension UIViewController {
	internal func topMostViewController() -> UIViewController {
		
		if let presented = self.presentedViewController {
			return presented.topMostViewController()
		}
		
		if let navigation = self as? UINavigationController {
			return navigation.visibleViewController?.topMostViewController() ?? navigation
		}
		
		if let tab = self as? UITabBarController {
			return tab.selectedViewController?.topMostViewController() ?? tab
		}
		
		return self
	}
	
	internal func topMostTabBarViewController() -> UIViewController {
		
		if let navigation = self as? UINavigationController {
			return navigation.visibleViewController?.topMostTabBarViewController() ?? navigation
		}
		
		return self
	}
}

