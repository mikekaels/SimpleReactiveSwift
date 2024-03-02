//
//  ProfileUseCase.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Combine

internal protocol ProfileUseCaseProtocol {
	func getUser() -> AnyPublisher<User, PersistenceError>
	func getPayments() -> AnyPublisher<Payments, PersistenceError>
	func getBanners() -> AnyPublisher<[String], PersistenceError>
}

internal final class ProfileUseCase {
	let repository: ProfileRepositoryProtocol
	
	init(repository: ProfileRepositoryProtocol = ProfileRepository()) {
		self.repository = repository
	}
}

extension ProfileUseCase: ProfileUseCaseProtocol {
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
