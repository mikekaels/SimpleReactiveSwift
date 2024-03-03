//
//  SimulationTests.swift
//  SimpleReactiveSwiftTests
//
//  Created by Santo Michael on 03/03/24.
//

import XCTest
import Combine

@testable import SimpleReactiveSwift

final class SimulationTests: XCTestCase {
	
	var viewModel: SimulationVM!
	var useCase: MockSimulationUseCase!
	var action: SimulationVM.Action!
	var cancellables: CancelBag!
	
	var marketPriceDidChangePublisher = PassthroughSubject<String?, Never>()
	var estReturnDidChangePublisher = PassthroughSubject<ESTReturnType, Never>()
	var didLoadPublisher = PassthroughSubject<Void, Never>()
	var calculateTotalInvestmentPublisher = PassthroughSubject<Void, Never>()
	var calculateDateFromAndToPublisher = PassthroughSubject<Void, Never>()
	
	override func setUp() {
		super.setUp()
		cancellables = CancelBag()
	}
	
	override func tearDown() {
		marketPriceDidChangePublisher = PassthroughSubject<String?, Never>()
		estReturnDidChangePublisher = PassthroughSubject<ESTReturnType, Never>()
		didLoadPublisher = PassthroughSubject<Void, Never>()
		useCase = nil
		viewModel = nil
		action = nil
		cancellables.cancel()
		super.tearDown()
	}
	
	func test_transform() {
		// Given
		useCase = MockSimulationUseCase()
		viewModel = SimulationVM(useCase: useCase)
		action = SimulationVM.Action(
			didLoad: didLoadPublisher,
			marketPriceDidChange: marketPriceDidChangePublisher.eraseToAnyPublisher(),
			estReturnDidChange: estReturnDidChangePublisher,
			calculateTotalInvestment: calculateTotalInvestmentPublisher,
			calculateDateFromAndTo: calculateDateFromAndToPublisher
		)
		
		// When
		let state = viewModel.transform(action, cancellables)
		
		// Then
		XCTAssertEqual(state.marketPrice, 0.0)
		XCTAssertEqual(state.yearlyProjection, 0)
		XCTAssertEqual(state.investmentDateFrom, "")
		XCTAssertEqual(state.investmentDateTo, "")
		XCTAssertEqual(state.qtyOwned, 0.0)
		XCTAssertEqual(state.totalInvestment, 0.0)
		XCTAssertEqual(state.estReturn, 5)
		XCTAssertEqual(state.estReturns.count, 4)
		
	}
	
	func test_shouldGetSimulationData_whenDidLoad() {
		// Given
		let marketPrice: Double = 150000
		let yearlyProjection: Double = 50
		let investmentDate: String =  "2023-11-05T12:08:56+07:00"
		let investmentDateTo: String =  "2028-11-05T12:08:56+07:00"
		let qtyOwned: Double = 5.3
		
		useCase = MockSimulationUseCase()
		useCase.investmentDate = investmentDate
		useCase.marketPrice = marketPrice
		useCase.yearlyProjection = yearlyProjection
		useCase.qtyOwned = qtyOwned
		
		viewModel = SimulationVM(useCase: useCase)
		action = SimulationVM.Action(
			didLoad: didLoadPublisher,
			marketPriceDidChange: marketPriceDidChangePublisher.eraseToAnyPublisher(),
			estReturnDidChange: estReturnDidChangePublisher,
			calculateTotalInvestment: calculateTotalInvestmentPublisher,
			calculateDateFromAndTo: calculateDateFromAndToPublisher
		)
		let state = viewModel.transform(action, cancellables)
		
		// When
		didLoadPublisher.send(())
		
		// Then
		wait {
			XCTAssertEqual(state.marketPrice, marketPrice)
			XCTAssertEqual(state.yearlyProjection, yearlyProjection)
			XCTAssertEqual(state.investmentDateFrom, investmentDate.toSimpleDateString())
			XCTAssertEqual(state.investmentDateTo, investmentDateTo.toSimpleDateString())
			XCTAssertEqual(state.qtyOwned, qtyOwned)
		}
	}
	
	func test_totalInvestmentChange_whenMarketPriceDidChange() {
		let marketPrice: Double = 1
		let yearlyProjection: Double = 1
		let investmentDate: String = "2023-11-05T12:08:56+07:00"
		let qtyOwned: Double = 1
		
		useCase = MockSimulationUseCase()
		useCase.investmentDate = investmentDate
		useCase.marketPrice = marketPrice
		useCase.yearlyProjection = yearlyProjection
		useCase.qtyOwned = qtyOwned
		
		viewModel = SimulationVM(useCase: useCase)
		action = SimulationVM.Action(
			didLoad: didLoadPublisher,
			marketPriceDidChange: marketPriceDidChangePublisher.eraseToAnyPublisher(),
			estReturnDidChange: estReturnDidChangePublisher,
			calculateTotalInvestment: calculateTotalInvestmentPublisher,
			calculateDateFromAndTo: calculateDateFromAndToPublisher
		)
		let state = viewModel.transform(action, cancellables)
		didLoadPublisher.send(())
		
		
		// When
		marketPriceDidChangePublisher.send("50000")
		
		// Then
		wait {
			XCTAssertEqual(state.marketPrice, 1)
			XCTAssertEqual(state.totalInvestment, 1)
		}
	}
	
	func test_totalInvestmentChange_whenEstReturnDidChange() {
		let marketPrice: Double = 150000
		let yearlyProjection: Double = 50
		let investmentDate: String =  "2023-11-05T12:08:56+07:00"
		let qtyOwned: Double = 5.3
		
		useCase = MockSimulationUseCase()
		useCase.investmentDate = investmentDate
		useCase.marketPrice = marketPrice
		useCase.yearlyProjection = yearlyProjection
		useCase.qtyOwned = qtyOwned
		
		viewModel = SimulationVM(useCase: useCase)
		action = SimulationVM.Action(
			didLoad: didLoadPublisher,
			marketPriceDidChange: marketPriceDidChangePublisher.eraseToAnyPublisher(),
			estReturnDidChange: estReturnDidChangePublisher,
			calculateTotalInvestment: calculateTotalInvestmentPublisher,
			calculateDateFromAndTo: calculateDateFromAndToPublisher
		)
		let state = viewModel.transform(action, cancellables)
		didLoadPublisher.send(())
		
		
		// When
		estReturnDidChangePublisher.send(.oneYear)
		
		// Then
		wait {
			XCTAssertEqual(state.estReturn, 1)
			XCTAssertEqual(state.totalInvestment, 0)
		}
	}
}

internal final class MockSimulationUseCase: SimulationUseCaseProtocol {
	
	
	var marketPrice: Double = 0.0
	var yearlyProjection: Double = 0.0
	var investmentDate: String = ""
	var qtyOwned: Double = 0.0
	
	func getTotalInvestment(marketPrice: Double, yearlyProjection: Double, qtyOwned: Double, estReturn: Double) -> Double {
		marketPrice * yearlyProjection * qtyOwned * estReturn
	}
	
	func getSimulation() -> AnyPublisher<Simulation, PersistenceError> {
		return Future<Simulation, PersistenceError> { [weak self] promise in
			guard let self = self else { return }
			promise(.success(Simulation(yearlyProjection: self.yearlyProjection, investmentDate: self.investmentDate, qtyOwned: self.qtyOwned, marketPrice: self.marketPrice)))
		}.eraseToAnyPublisher()
	}
}
