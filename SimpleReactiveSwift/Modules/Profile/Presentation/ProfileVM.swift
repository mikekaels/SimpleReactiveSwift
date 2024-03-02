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
	
	enum Section: Hashable {
		case main
	}
	
	enum SectionDataSourceType: Hashable {
		case userSection(StateType<User>)
		case paymentsSection(StateType<Payments>)
		case bannersSection(StateType<[String]>)
		case defaultMenuSection(title: String, items: [MenuDataSourceType])
	}
	
	enum MenuDataSourceType: Hashable {
		case referral
		case invitation
		case notification
		case darkMode(Bool)
		case version(String)
		case legal
		case logout
		
		var title: String {
			switch self {
			case .referral: return "Reverral"
			case .invitation: return"Invitation"
			case .notification: return "Notification"
			case .darkMode: return "Dark Mode"
			case .version: return "Version"
			case .legal: return "Legal"
			case .logout: return "Logout"
			}
		}
		
		var valueType: MenuValueType {
			switch self {
			case .referral: return .chevronButton
			case .invitation: return .chevronButton
			case .notification: return .chevronButton
			case .darkMode: return .switchButton
			case .version: return .text
			case .legal: return .chevronButton
			case .logout: return .none
			}
		}
		
		enum MenuValueType {
			case chevronButton
			case switchButton
			case text
			case none
		}
	}
	
	enum ActionType {
		case `default`(ProfileVM.MenuDataSourceType)
		case `switch`(ProfileVM.MenuDataSourceType, Bool)
	}
	
	enum StateType<T: Hashable>: Hashable {
		case loading
		case content(T)
	}
}

extension ProfileVM {
	struct Action {
		let didLoad: AnyPublisher<Void, Never>
		let menuDidTap: AnyPublisher<ActionType, Never>
		let getUser = PassthroughSubject<Void, Never>()
		let getPayments = PassthroughSubject<Void, Never>()
		let getBanners = PassthroughSubject<Void, Never>()
	}
	
	class State {
		@Published var dataSources: [SectionDataSourceType] = [
			.userSection(.loading),
			.paymentsSection(.loading),
			.bannersSection(.loading)
		]
	}
	
	func transform(_ action: Action, _ cancellables: CancelBag) -> State {
		let state = State()
		let isDarkMode = self.useCase.isDarkModeOn()
		self.useCase.switchAppearence(to: isDarkMode ? .dark : .light)
		
		let menus: [SectionDataSourceType] = [
			.defaultMenuSection(title: "Promotions" , items: [
				.referral,
				.invitation,
			]),
			.defaultMenuSection(title: "Setting" , items: [
				.notification,
				.darkMode(isDarkMode),
			]),
			.defaultMenuSection(title: "System" , items: [
				.version("1.0.0"),
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
					guard let userIndex = state.dataSources.firstIndex(where: {
						if case .userSection = $0 { return true }
						return false
					}) else { return }
					let section = state.dataSources[userIndex]
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						state.dataSources[userIndex] = .userSection (.content(user))
					}
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
					guard let paymentIndex = state.dataSources.firstIndex(where: {
						if case .paymentsSection  = $0 { return true }
						return false
					}) else { return }
					let section = state.dataSources[paymentIndex]
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						state.dataSources[paymentIndex] = .paymentsSection (.content(payment))
					}
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
					guard let bannerIndex = state.dataSources.firstIndex(where: {
						if case .bannersSection  = $0 { return true }
						return false
					}) else { return }
					let section = state.dataSources[bannerIndex]
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						state.dataSources[bannerIndex] = .bannersSection (.content(banners))
					}
				}
			}
			.store(in: cancellables)
		
		action.menuDidTap
			.sink { [weak self] actionType in
				if case let .default(menu) = actionType {
					Routing.push(.simulation)
				}
				
				if case let .switch(menu, isOn) = actionType {
					self?.useCase.switchAppearence(to: isOn ? .dark : .light)
				}
			}
			.store(in: cancellables)
		
		return state
	}
}
