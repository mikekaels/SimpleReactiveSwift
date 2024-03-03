//
//  Route.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Foundation

internal enum Route {
	case simulation
	case component(Component)
	
	enum Component {
		case alert(firstCompletion: (() -> Void)? = nil,
				   secondCompletion: (() -> Void)? = nil
		)
	}
}
