//
//  ProfileRepositoryTests.swift
//  SimpleReactiveSwiftTests
//
//  Created by Santo Michael on 03/03/24.
//

import XCTest
import Combine
@testable import SimpleReactiveSwift

class ProfileRepositoryTests: XCTestCase {
	func test_successGetUserFromPersistence_whenGetUser() {
		// Given
		let expectation = XCTestExpectation(description: "Get user completed")
		let persistence = MockSuccessPersistenceManager()
		let repository = ProfileRepository(persistence: persistence)
		
		// When
		_ = repository.getUser().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTFail("Get user failed with error: \(error)")
			}
		} receiveValue: { user in
			XCTAssertEqual(user, User(name: "Magician", isVerified: true))
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_successGetPaymentsFromPersistence_whenGetPayments() {
		// Given
		let expectation = XCTestExpectation(description: "Get payments completed")
		let persistence = MockSuccessPersistenceManager()
		let repository = ProfileRepository(persistence: persistence)
		
		// When
		_ = repository.getPayments().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTFail("Get payments failed with error: \(error)")
			}
		} receiveValue: { payments in
			XCTAssertEqual(payments, Payments(balance: 1, inProcessBalance: 2))
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_successGetbannersFromPersistence_whenGetBanners() {
		// Given
		let expectation = XCTestExpectation(description: "Get baners completed")
		let persistence = MockSuccessPersistenceManager()
		let repository = ProfileRepository(persistence: persistence)
		
		// When
		_ = repository.getBanners().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTFail("Get banners failed with error: \(error)")
			}
		} receiveValue: { banners in
			XCTAssertEqual(banners, ["ban", "ner"])
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_failedGetUserFromPersistence_whenGetUser_whereFileNotFound() {
		// Given
		let expectation = XCTestExpectation(description: "Get user completed")
		let persistence = MockFailedPersistenceManager()
		let repository = ProfileRepository(persistence: persistence)
		
		// When
		_ = repository.getUser().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTAssertEqual(error, PersistenceError.fileNotFound)
				expectation.fulfill()
			}
		} receiveValue: { user in
			XCTFail("Expected failure, but received a value")
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_failedGetPaymentsFromPersistence_whenGetPayments_whereFileNotFound() {
		// Given
		let expectation = XCTestExpectation(description: "Get payments completed")
		let persistence = MockFailedPersistenceManager()
		let repository = ProfileRepository(persistence: persistence)
		
		// When
		_ = repository.getPayments().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTAssertEqual(error, PersistenceError.fileNotFound)
				expectation.fulfill()
			}
		} receiveValue: { user in
			XCTFail("Expected failure, but received a value")
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_failedGetBannersFromPersistence_whenGetBanners_whereFileNotFound() {
		// Given
		let expectation = XCTestExpectation(description: "Get banners completed")
		let persistence = MockFailedPersistenceManager()
		let repository = ProfileRepository(persistence: persistence)
		
		// When
		_ = repository.getBanners().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTAssertEqual(error, PersistenceError.fileNotFound)
				expectation.fulfill()
			}
		} receiveValue: { user in
			XCTFail("Expected failure, but received a value")
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
}
