//
//  ProfileUseCaseTests.swift
//  SimpleReactiveSwiftTests
//
//  Created by Santo Michael on 03/03/24.
//


import XCTest
import Combine
@testable import SimpleReactiveSwift

class ProfileUseCaseTests: XCTestCase {
	
	func test_useCaseShouldGetUser_whenGetUserCalled() {
		// Given
		let expectation = XCTestExpectation(description: "Get user completed")
		let user = User(name: "Magic", isVerified: true)
		let repository = MockProfileRepository(user: user)
		let useCase = ProfileUseCase(repository: repository)
		
		// When
		_ = useCase.getUser().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTFail("Get user failed with error: \(error)")
			}
		} receiveValue: { userResult in
			XCTAssertEqual(userResult, user)
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_useCaseShouldGetBanners_whenGetBannersCalled() {
		// Given
		let expectation = XCTestExpectation(description: "Get banners completed")
		let banners = ["magic","cian"]
		let repository = MockProfileRepository(banners: banners)
		let useCase = ProfileUseCase(repository: repository)
		
		// When
		_ = useCase.getBanners().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTFail("Get user failed with error: \(error)")
			}
		} receiveValue: { bannersResult in
			XCTAssertEqual(bannersResult, banners)
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_useCaseShouldGetPayments_whenGetPaymentsCalled() {
		// Given
		let expectation = XCTestExpectation(description: "Get payments completed")
		let payments = Payments(balance: 1999, inProcessBalance: 0)
		let repository = MockProfileRepository(payments: payments)
		let useCase = ProfileUseCase(repository: repository)
		
		// When
		_ = useCase.getPayments().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTFail("Get user failed with error: \(error)")
			}
		} receiveValue: { paymentsResult in
			XCTAssertEqual(paymentsResult, payments)
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_logout_whenDoLogoutCalled() {
		// Given
		let expectation = XCTestExpectation(description: "Logout completed")
		let useCase = ProfileUseCase()
		
		// When
		useCase.doLogout()
		
		// Then
		print("Logged out")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 2)
	}
}

class MockProfileRepository: ProfileRepositoryProtocol {
	let user: User
	let banners: [String]
	let payments: Payments
	
	init(
		user: User = User(name: "Magician", isVerified: false),
		banners: [String] = ["ban", "ner"],
		payments: Payments = Payments(balance: 0, inProcessBalance: 0)
	) {
		self.user = user
		self.banners = banners
		self.payments = payments
	}
	
	func getBanners() -> AnyPublisher<[String], PersistenceError> {
		return Future<[String], PersistenceError> { [weak self] promise in
			guard let self = self else { return }
			promise(.success(self.banners))
		}.eraseToAnyPublisher()
	}
	
	func getPayments() -> AnyPublisher<Payments, PersistenceError> {
		return Future<Payments, PersistenceError> { [weak self] promise in
			guard let self = self else { return }
			promise(.success(self.payments))
		}.eraseToAnyPublisher()
	}
	
	func getUser() -> AnyPublisher<User, PersistenceError> {
		return Future<User, PersistenceError> { [weak self] promise in
			guard let self = self else { return }
			promise(.success(self.user))
		}.eraseToAnyPublisher()
	}
}
