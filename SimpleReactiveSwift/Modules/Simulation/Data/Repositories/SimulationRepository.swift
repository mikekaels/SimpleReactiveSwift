//
//  SimulationRepository.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Combine

internal protocol SimulationRepositoryProtocol {
	func getSimulation() -> AnyPublisher<Simulation, PersistenceError>
}

internal final class SimulationRepository {
	let persistence: PersistenceManagerProtocol
	
	init(persistence: PersistenceManagerProtocol = PersistenceManager()) {
		self.persistence = persistence
	}
}

extension SimulationRepository: SimulationRepositoryProtocol {
	func getSimulation() -> AnyPublisher<Simulation, PersistenceError> {
		do {
			let result: SimulationResponse = try persistence.loadObject(from: "SIMULATION")
			return Future<Simulation, PersistenceError> { promise in
				promise(.success(result.toDomain()))
			}
			.eraseToAnyPublisher()
		}
		catch {
			return Future<Simulation, PersistenceError> { promise in
				promise(.failure(error as! PersistenceError))
			}
			.eraseToAnyPublisher()
		}
	}
}

