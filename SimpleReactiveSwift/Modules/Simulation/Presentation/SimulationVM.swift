//
//  SimulationVM.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Combine
import Foundation

internal final class SimulationVM {
	
	let useCase: SimulationUseCaseProtocol
	
	init(useCase: SimulationUseCaseProtocol = SimulationUseCase()) {
		self.useCase = useCase
	}
}

extension SimulationVM {
	struct Action {
		let didLoad: PassthroughSubject<Void, Never>
		let marketPriceDidChange: AnyPublisher<String?, Never>
		let estReturnDidChange: PassthroughSubject<ESTReturnType, Never>
		let calculateTotalInvestment: PassthroughSubject<Void, Never>
		let calculateDateFromAndTo: PassthroughSubject<Void, Never>
	}
	
	class State {
		@Published var marketPrice: Double = 0.0
		@Published var yearlyProjection: Double = 0
		@Published var investmentDateFrom: String = ""
		@Published var investmentDateTo: String = ""
		@Published var qtyOwned: Double = 0.0
		@Published var totalInvestment: Double = 0.0
		@Published var estReturn: Double = 5
		@Published var estReturns: [ESTReturnType] = [.sixMonth, .oneYear, .threeYear, .fiveYear]
	}
	
	func transform(_ action: Action, _ cancellables: CancelBag) -> State {
		let state = State()
		
		action.didLoad
			.receive(on: DispatchQueue.global())
			.flatMap {
				self.useCase.getSimulation()
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case let .failure(error) = result {
					
				}
				
				if case let .success(simulation) = result {
					state.marketPrice = simulation.marketPrice
					state.yearlyProjection = simulation.yearlyProjection
					state.investmentDateFrom = simulation.investmentDate.toSimpleDateString()
					state.qtyOwned = simulation.qtyOwned
					
					action.calculateDateFromAndTo.send(())
					action.calculateTotalInvestment.send(())
				}
				
			}
			.store(in: cancellables)
		
		action.calculateTotalInvestment
			.sink { [weak self] _ in
				guard let self = self else { return }
				let result = self.useCase.getTotalInvestment(marketPrice: state.marketPrice,
															 yearlyProjection: state.yearlyProjection,
															 qtyOwned: state.qtyOwned,
															 estReturn: state.estReturn)
				state.totalInvestment = result
			}
			.store(in: cancellables)
		
		action.calculateDateFromAndTo
			.sink { _ in
				state.investmentDateTo = state.investmentDateFrom.calculateMonthsLater(n: Int(state.estReturn * 12.0)) ?? ""
			}
			.store(in: cancellables)
		
		action.marketPriceDidChange
			.sink { marketPrice in
				if let marketPrice = marketPrice {
					state.marketPrice = marketPrice.toDouble()
					action.calculateTotalInvestment.send(())
				}
			}
			.store(in: cancellables)
		
		action.estReturnDidChange
			.sink { type in
				state.estReturn = type.value
				action.calculateDateFromAndTo.send(())
				action.calculateTotalInvestment.send(())
			}
			.store(in: cancellables)
		
		return state
	}
}
