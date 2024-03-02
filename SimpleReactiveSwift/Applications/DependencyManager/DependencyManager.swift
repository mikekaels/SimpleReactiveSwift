//
//  DependencyManager.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import IQKeyboardManagerSwift

internal enum DependencyManager {
	@MainActor static func setup() {
		RoutingDependencyManager.setup()
		IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.resignOnTouchOutside = true
		IQKeyboardManager.shared.enableAutoToolbar = false
	}
}
