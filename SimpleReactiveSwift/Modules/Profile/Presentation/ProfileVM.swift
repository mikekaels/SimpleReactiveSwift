//
//  ProfileVM.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Foundation
import Combine

final class ProfileVM {
	private let useCase: ProfileUseCaseProtocol
	
	init(useCase: ProfileUseCaseProtocol = ProfileUseCase()) {
		self.useCase = useCase
	}
	
	enum DataSourceType: Hashable {
		case user(User)
		case payment(Payments)
		case banners([String])
	}
}

extension ProfileVM {
	struct Action {
		let didLoad: AnyPublisher<Void, Never>
		let getUser = PassthroughSubject<Void, Never>()
		let getPayments = PassthroughSubject<Void, Never>()
		let getBanners = PassthroughSubject<Void, Never>()
	}
	
	class State {
		
	}
	
	func transform(_ action: Action, _ cancellables: CancelBag) -> State {
		let state = State()
		
		action.didLoad
			.sink { _ in
				action.getUser.send(())
				action.getPayments.send(())
				action.getBanners.send(())
			}
			.store(in: cancellables)
		
		action.getUser
			.flatMap {
				self.useCase.getUser()
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case let .failure(error) = result {
					print(error)
				}
				if case let .success(user) = result {
					print(user)
				}
			}
			.store(in: cancellables)
		
		action.getPayments
			.flatMap {
				self.useCase.getPayments()
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case let .failure(error) = result {
					print(error)
				}
				if case let .success(payment) = result {
					print(payment)
				}
			}
			.store(in: cancellables)
		
		action.getBanners
			.flatMap {
				self.useCase.getBanners()
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case let .failure(error) = result {
					print(error)
				}
				if case let .success(banners) = result {
					print(banners)
				}
			}
			.store(in: cancellables)
		
		return state
	}
}
