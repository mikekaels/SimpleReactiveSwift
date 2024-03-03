//
//  SimulationRepositoryTests.swift
//  SimpleReactiveSwiftTests
//
//  Created by Santo Michael on 03/03/24.
//

import XCTest
import Combine
@testable import SimpleReactiveSwift

class SimulationRepositoryTests: XCTestCase {
	func test_successGetSimulationFromPersistence_whenGetSimulation() {
		// Given
		let expectation = XCTestExpectation(description: "Get simulation completed")
		let persistence = MockSuccessPersistenceManager()
		let repository = SimulationRepository(persistence: persistence)
		
		// When
		_ = repository.getSimulation().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTFail("Get simulation failed with error: \(error)")
			}
		} receiveValue: { simulation in
			XCTAssertEqual(simulation, Simulation(yearlyProjection: 1.0, investmentDate: "2023-11-05T12:08:56+07:00", qtyOwned: 1.0, marketPrice: 1.0))
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_failedGetSimulationFromPersistence_whenGetSimulationCalled_whereFileNotFound() {
		// Given
		let expectation = XCTestExpectation(description: "Get simulation completed")
		let persistence = MockFailedPersistenceManager()
		let repository = SimulationRepository(persistence: persistence)
		
		// When
		_ = repository.getSimulation().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTAssertEqual(error, PersistenceError.fileNotFound)
				expectation.fulfill()
			}
		} receiveValue: { _ in
			XCTFail("Expected failure, but received a value")
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
}

