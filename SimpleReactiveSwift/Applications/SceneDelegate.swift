//
//  SceneDelegate.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: scene)
		let nav = UINavigationController(rootViewController: ProfileVC())
		window?.rootViewController = nav
		window?.makeKeyAndVisible()
	}
}

