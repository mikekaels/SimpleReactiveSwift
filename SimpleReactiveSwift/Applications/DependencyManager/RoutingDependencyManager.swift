//
//  RoutingDependencyManager.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

internal enum RoutingDependencyManager {
	static func setup() {
		Routing.route = { params in
			RoutingDependencyManager.handleRouting(method: params.method, route: params.route, animated: params.animated, isFullScreen: params.isFullScreen, routeCompletion: params.atlasCompletion)
		}
	}
	
	static func handleRouting(method: Routing.RoutingNavigationMethod, route: Route, animated: Bool, isFullScreen: Bool, routeCompletion: (() -> Void)?) {
		guard let topVC = UIApplication.topMostVC() else { return }
		var viewController: UIViewController {
			get {
				UIApplication.topMostVC() ?? topVC
			}
		}
		
		switch route {
		case .simulation:
			let vm = SimulationVM()
			let vc = SimulationVC(viewModel: vm)
			Routing.navigationMethodHandler(method: method, vc: vc, from: viewController, animated: animated, isFullScreen: isFullScreen, completion: routeCompletion)
		case .component:
			break
		}
	}
}
