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
}

extension ProfileVM {
	struct Action {
		let didLoad: PassthroughSubject<Void, Never>
		let menuDidTap: PassthroughSubject<MenuActionType, Never>
		let getUser: PassthroughSubject<Void, Never>
		let getPayments: PassthroughSubject<Void, Never>
		let getBanners: PassthroughSubject<Void, Never>
	}
	
	class State {
		@Published var dataSources: [ProfileSectionDataSourceType] = [
			.userSection(.loading),
			.paymentsSection(.loading)
		]
	}
	
	func transform(_ action: Action, _ cancellables: CancelBag) -> State {
		let state = State()
		let isDarkMode = self.useCase.isDarkModeOn()
		self.useCase.switchAppearence(to: isDarkMode ? .dark : .light)
		let version = self.useCase.getVersion()
		
		let menus: [ProfileSectionDataSourceType] = [
			.defaultMenuSection(title: "Promotions" , items: [
				.referral,
				.invitation,
			]),
			.defaultMenuSection(title: "Setting" , items: [
				.notification,
				.darkMode(isDarkMode),
			]),
			.defaultMenuSection(title: "System" , items: [
				.version(version),
				.legal,
			]),
			.defaultMenuSection(title: "Logout" , items: [
				.logout
			])
		]
		
		state.dataSources.append(contentsOf: menus)
		
		action.didLoad
			.sink { _ in
				action.getUser.send(())
				action.getPayments.send(())
			}
			.store(in: cancellables)
		
		action.getUser
			.receive(on: DispatchQueue.global())
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
					if user.isVerified {
						action.getBanners.send(())
					}
					
					guard let userIndex = state.dataSources.firstIndex(where: {
						if case .userSection = $0 { return true }
						return false
					}) else { return }
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						state.dataSources[userIndex] = .userSection (.content(user))
					}
				}
			}
			.store(in: cancellables)
		
		action.getPayments
			.receive(on: DispatchQueue.global())
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
					guard let paymentIndex = state.dataSources.firstIndex(where: {
						if case .paymentsSection  = $0 { return true }
						return false
					}) else { return }
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						state.dataSources[paymentIndex] = .paymentsSection (.content(payment))
					}
				}
			}
			.store(in: cancellables)
		
		action.getBanners
			.receive(on: DispatchQueue.global())
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
					guard !banners.isEmpty, let paymentIndex = state.dataSources.firstIndex(where: {
						if case .paymentsSection  = $0 { return true }
						return false
					}) else { return }
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						state.dataSources.insert(.bannersSection (.content(banners)), at: paymentIndex + 1)
					}
				}
			}
			.store(in: cancellables)
		
		action.menuDidTap
			.sink { [weak self] actionType in
				if case let .default(menu) = actionType, case .logout = menu {
					self?.useCase.showAlert(firstCompletion: { [weak self] in
						self?.useCase.doLogout()
					}, secondCompletion: {
						print("alert cancelled")
					})
				}
				
				else if case let .default(menu) = actionType {
					self?.useCase.goToSimulation()
				}
				
				if case let .switch(_, isOn) = actionType {
					self?.useCase.switchAppearence(to: isOn ? .dark : .light)
				}
			}
			.store(in: cancellables)
		
		return state
	}
}
