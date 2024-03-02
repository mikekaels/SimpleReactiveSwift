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
}

internal final class ProfileUseCase {
	let repository: ProfileRepositoryProtocol
	
	init(repository: ProfileRepositoryProtocol = ProfileRepository()) {
		self.repository = repository
	}
}

extension ProfileUseCase: ProfileUseCaseProtocol {
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
