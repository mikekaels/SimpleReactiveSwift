//
//  SimulationUseCaseTests.swift
//  SimpleReactiveSwiftTests
//
//  Created by Santo Michael on 03/03/24.
//

import XCTest
import Combine
@testable import SimpleReactiveSwift

class SimulationUseCaseTests: XCTestCase {
	
	func test_useCaseShouldGetSiulation_whenGetSimulationCalled() {
		// Given
		let expectation = XCTestExpectation(description: "Get simulation completed")
		let repository = MockSimulationRepository()
		let useCase = SimulationUseCase(repository: repository)
		
		// When
		_ = useCase.getSimulation().sink { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure(let error):
				XCTFail("Get simulation failed with error: \(error)")
			}
		} receiveValue: { simulationResult in
			XCTAssertEqual(simulationResult, Simulation(yearlyProjection: 83, investmentDate: "2023-11-05T12:08:56+07:00", qtyOwned: 10, marketPrice: 120_000))
		}
		
		// Then
		wait(for: [expectation], timeout: 2)
	}
	
	func test_useCaseShouldCalculateTotalInvestment_whenGetTotalInvestmentCalled() {
		// Given
		let expectation = XCTestExpectation(description: "Get total investment completed")
		let useCase = SimulationUseCase()
		
		// When
		let totalInvestment = useCase.getTotalInvestment(marketPrice: 1.0, yearlyProjection: 1.0, qtyOwned: 1.0, estReturn: 1.0)
			
		// Then
		XCTAssertEqual(totalInvestment, 1)
		expectation.fulfill()
	}
}

class MockSimulationRepository: SimulationRepositoryProtocol {
	func getSimulation() -> AnyPublisher<Simulation, PersistenceError> {
		return Future<Simulation, PersistenceError> { promise in
			promise(.success(Simulation(yearlyProjection: 83, investmentDate: "2023-11-05T12:08:56+07:00", qtyOwned: 10, marketPrice: 120_000)))
		}.eraseToAnyPublisher()
	}
}

