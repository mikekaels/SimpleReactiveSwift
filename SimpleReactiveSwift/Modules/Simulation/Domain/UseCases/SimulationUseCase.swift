//
//  SimulationUseCase.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Combine

internal protocol SimulationUseCaseProtocol {
	func getSimulation() -> AnyPublisher<Simulation, PersistenceError>
	func getTotalInvestment(marketPrice: Double, yearlyProjection: Double, qtyOwned: Double, estReturn: Double) -> Double
}

internal final class SimulationUseCase {
	let repository: SimulationRepositoryProtocol
	
	init(repository: SimulationRepositoryProtocol = SimulationRepository()) {
		self.repository = repository
	}
}

extension SimulationUseCase: SimulationUseCaseProtocol {
	func getTotalInvestment(marketPrice: Double, yearlyProjection: Double, qtyOwned: Double, estReturn: Double) -> Double {
		return marketPrice * yearlyProjection * qtyOwned * estReturn
	}
	
	func getSimulation() -> AnyPublisher<Simulation, PersistenceError> {
		repository.getSimulation()
	}
}
