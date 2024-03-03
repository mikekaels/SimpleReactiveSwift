//
//  ProfileUseCase.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Combine
import UIKit

internal protocol ProfileUseCaseProtocol {
	func getUser() -> AnyPublisher<User, PersistenceError>
	func getPayments() -> AnyPublisher<Payments, PersistenceError>
	func getBanners() -> AnyPublisher<[String], PersistenceError>
	func isDarkModeOn() -> Bool
	func switchAppearence(to: UIUserInterfaceStyle)
	func getVersion() -> String
	func doLogout()
	func showAlert(firstCompletion: @escaping (() -> Void), secondCompletion: @escaping (() -> Void))
	func goToSimulation()
}

internal final class ProfileUseCase {
	let repository: ProfileRepositoryProtocol
	
	init(repository: ProfileRepositoryProtocol = ProfileRepository()) {
		self.repository = repository
	}
}

extension ProfileUseCase: ProfileUseCaseProtocol {
	func goToSimulation() {
		Routing.push(.simulation)
	}
	
	func showAlert(firstCompletion: @escaping (() -> Void), secondCompletion: @escaping (() -> Void)) {
		Routing.present(.component(.alert(firstCompletion: firstCompletion, secondCompletion: secondCompletion)))
	}
	
	func doLogout() {
		print("do logout")
	}
	
	func getVersion() -> String {
		return "1.0.1"
	}
	
	func switchAppearence(to style: UIUserInterfaceStyle) {
		if let window = UIApplication.shared.keyWindow {
			UIView.transition (with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
				window.overrideUserInterfaceStyle = style //.light or .unspecified
			}) { isComplete in
				UserDefaults.standard.setValue(style == .dark, forKey: "isDarkModeOn")
			}
		}
	}
	
	func isDarkModeOn() -> Bool {
		UserDefaults.standard.bool(forKey: "isDarkModeOn")
	}
	
	func getBanners() -> AnyPublisher<[String], PersistenceError> {
		return repository.getBanners()
	}
	
	func getPayments() -> AnyPublisher<Payments, PersistenceError> {
		return repository.getPayments()
	}
	
	func getUser() -> AnyPublisher<User, PersistenceError> {
		return repository.getUser()
	}
}
