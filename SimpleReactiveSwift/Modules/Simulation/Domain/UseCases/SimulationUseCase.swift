//
//  SimulationUseCase.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Combine

internal protocol SimulationUseCaseProtocol {
	func getSimulation() -> AnyPublisher<Simulation, PersistenceError>
}

internal final class SimulationUseCase {
	let repository: SimulationRepositoryProtocol
	
	init(repository: SimulationRepositoryProtocol = SimulationRepository()) {
		self.repository = repository
	}
}

extension SimulationUseCase: SimulationUseCaseProtocol {
	func getSimulation() -> AnyPublisher<Simulation, PersistenceError> {
		repository.getSimulation()
	}
}
