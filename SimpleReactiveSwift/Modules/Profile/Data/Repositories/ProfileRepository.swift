//
//  ProfileRepository.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Combine

internal protocol ProfileRepositoryProtocol {
	func getUser() -> AnyPublisher<User, PersistenceError>
	func getPayments() -> AnyPublisher<Payments, PersistenceError>
	func getBanners() -> AnyPublisher<[String], PersistenceError>
}

internal final class ProfileRepository {
	let persistence: PersistenceManager
	
	init(persistence: PersistenceManager = PersistenceManager()) {
		self.persistence = persistence
	}
}

extension ProfileRepository: ProfileRepositoryProtocol {
	func getBanners() -> AnyPublisher<[String], PersistenceError> {
		do {
			let result: BannersDataResponse = try persistence.loadObject(from: "BANNERS")
			return Future<[String], PersistenceError> { promise in
				promise(.success(result.toDomain()))
			}
			.eraseToAnyPublisher()
		}
		catch {
			return Future<[String], PersistenceError> { promise in
				promise(.failure(error as! PersistenceError))
			}
			.eraseToAnyPublisher()
		}
	}
	
	func getPayments() -> AnyPublisher<Payments, PersistenceError> {
		do {
			let result: PaymentsResponse<PaymentsDataResponse> = try persistence.loadObject(from: "PAYMENTS")
			return Future<Payments, PersistenceError> { promise in
				promise(.success(result.payments!.toDomain()))
			}
			.eraseToAnyPublisher()
		}
		catch {
			return Future<Payments, PersistenceError> { promise in
				promise(.failure(error as! PersistenceError))
			}
			.eraseToAnyPublisher()
		}
	}
	
	func getUser() -> AnyPublisher<User, PersistenceError> {
		do {
			let result: UserResponse<UserDataResponse> = try persistence.loadObject(from: "USER")
			return Future<User, PersistenceError> { promise in
				promise(.success(result.user!.toDomain()))
			}
			.eraseToAnyPublisher()
		}
		catch {
			return Future<User, PersistenceError> { promise in
				promise(.failure(error as! PersistenceError))
			}
			.eraseToAnyPublisher()
		}
	}
}
