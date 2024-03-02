//
//  Routing.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

internal class Routing {
	struct RouterParameters {
		public let method: RoutingNavigationMethod
		public let route: Route
		public let animated: Bool
		public var isFullScreen: Bool = false
		public var atlasCompletion: (() -> Void)?
	}
	
	static var route: ((RouterParameters) -> Void)?
	
	enum RoutingNavigationMethod: String {
		case push = "(pushed)"
		case present = "(presented)"
	}
	
	static func navigationMethodHandler(method: RoutingNavigationMethod, vc: UIViewController, from: UIViewController, animated: Bool, isFullScreen: Bool = false, completion: (() -> Void)?) {
		
		if case .push = method {
			from.navigationController?.pushViewController(vc, animated: animated)
			if let completion = completion {
				completion()
			}
		}
		
		if case .present = method {
			if isFullScreen {
				let nav = UINavigationController(rootViewController: vc)
				nav.modalPresentationStyle = .fullScreen
				from.navigationController?.present(nav, animated: animated, completion: completion)
			} else {
				from.navigationController?.present(vc, animated: animated, completion: completion)
			}
		}
	}
	
	static func push(_ route: Route, animated: Bool = true, completion: (() -> Void)? = nil) {
		let params = RouterParameters(method: .push, route: route, animated: animated, atlasCompletion: completion)
		
		DispatchQueue.main.async {
			Routing.route?(params)
		}
	}
	
	/// Present Global route
	static func present(_ route: Route, animated: Bool = true, isFullScreen: Bool = false, completion: (() -> Void)? = nil) {
		let params = RouterParameters(method: .present, route: route, animated: animated, isFullScreen: isFullScreen, atlasCompletion: completion)
		
		DispatchQueue.main.async {
			Routing.route?(params)
		}
	}
}
