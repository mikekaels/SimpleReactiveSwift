//
//  ProfileTests.swift
//  SimpleReactiveSwiftTests
//
//  Created by Santo Michael on 03/03/24.
//

import XCTest
import Combine

@testable import SimpleReactiveSwift

final class ProfileTests: XCTestCase {

	var viewModel: ProfileVM!
	var useCase: MockProfileUseCase!
	var action: ProfileVM.Action!
	var cancellables: CancelBag!
	
	var menuDidTapPublisher = PassthroughSubject<MenuActionType, Never>()
	var didLoadPublisher = PassthroughSubject<Void, Never>()
	var getUserPublisher = PassthroughSubject<Void, Never>()
	var getPaymentsPublisher = PassthroughSubject<Void, Never>()
	var getBannersPublisher = PassthroughSubject<Void, Never>()
	
	override func setUp() {
		super.setUp()
		cancellables = CancelBag()
	}
	
	override func tearDown() {
		menuDidTapPublisher = PassthroughSubject<MenuActionType, Never>()
		didLoadPublisher = PassthroughSubject<Void, Never>()
		useCase = nil
		viewModel = nil
		action = nil
		cancellables = nil
		super.tearDown()
	}
	
	func test_transform() {
		// Given
		useCase = MockProfileUseCase()
		viewModel = ProfileVM(useCase: useCase)
		action = ProfileVM.Action(
			didLoad: didLoadPublisher,
			menuDidTap: menuDidTapPublisher,
			getUser: getUserPublisher,
			getPayments: getPaymentsPublisher,
			getBanners: getBannersPublisher
		)
		
		// When
		let state = viewModel.transform(action, cancellables)
		
		// Then
		XCTAssertEqual(state.dataSources.count, 6)
	}
	
	func test_shouldGetBanners_whenUserIsVerified() {
		// Given
		useCase = MockProfileUseCase()
		useCase.userIsVerified = true
		viewModel = ProfileVM(useCase: useCase)
		action = ProfileVM.Action(
			didLoad: didLoadPublisher,
			menuDidTap: menuDidTapPublisher,
			getUser: getUserPublisher,
			getPayments: getPaymentsPublisher,
			getBanners: getBannersPublisher
		)
		let state = viewModel.transform(action, cancellables)
		
		// When
		didLoadPublisher.send(())
		
		// Then
		let bannerIsExist = state.dataSources.contains(where: {
			if case .bannersSection = $0 { return true }
			return false
		})
		wait(timeout: 5) {
			XCTAssertTrue(bannerIsExist)
		}
	}
	
	func test_styleShouldChangeToDark_whenDarkModeSwitchOn() {
		// Given
		useCase = MockProfileUseCase()
		viewModel = ProfileVM(useCase: useCase)
		action = ProfileVM.Action(
			didLoad: didLoadPublisher,
			menuDidTap: menuDidTapPublisher,
			getUser: getUserPublisher,
			getPayments: getPaymentsPublisher,
			getBanners: getBannersPublisher
		)
		let state = viewModel.transform(action, cancellables)
		
		// When
		let value = true
		menuDidTapPublisher.send(.switch(.darkMode(false), value))
		
		// Then
		wait { [weak self] in
			XCTAssertEqual(self?.useCase.switchAppearence, value)
		}
	}
	
	func test_styleShouldChangeToLight_whenDarkModeSwitchedOff() {
		// Given
		useCase = MockProfileUseCase()
		viewModel = ProfileVM(useCase: useCase)
		action = ProfileVM.Action(
			didLoad: didLoadPublisher,
			menuDidTap: menuDidTapPublisher,
			getUser: getUserPublisher,
			getPayments: getPaymentsPublisher,
			getBanners: getBannersPublisher
		)
		let state = viewModel.transform(action, cancellables)
		
		// When
		let value = false
		menuDidTapPublisher.send(.switch(.darkMode(true), value))
		
		// Then
		wait { [weak self] in
			XCTAssertEqual(self?.useCase.switchAppearence, value)
		}
	}
	
	func test_showAlertLogout_whenLogoutDidTap() {
		// Given
		useCase = MockProfileUseCase()
		viewModel = ProfileVM(useCase: useCase)
		action = ProfileVM.Action(
			didLoad: didLoadPublisher,
			menuDidTap: menuDidTapPublisher,
			getUser: getUserPublisher,
			getPayments: getPaymentsPublisher,
			getBanners: getBannersPublisher
		)
		_ = viewModel.transform(action, cancellables)
		
		// When
		menuDidTapPublisher.send(.default(.logout))
		
		// Then
		XCTAssertTrue(self.useCase.showAlertDidShow)
	}
	
	func test_navigateToSimulation_whenMenuDidTap() {
		// Given
		useCase = MockProfileUseCase()
		viewModel = ProfileVM(useCase: useCase)
		action = ProfileVM.Action(
			didLoad: didLoadPublisher,
			menuDidTap: menuDidTapPublisher,
			getUser: getUserPublisher,
			getPayments: getPaymentsPublisher,
			getBanners: getBannersPublisher
		)
		_ = viewModel.transform(action, cancellables)
		
		// When
		menuDidTapPublisher.send(.default(.default))
		
		// Then
		XCTAssertTrue(self.useCase.didnNavigateToSimulation)
	}
}

internal final class MockProfileUseCase: ProfileUseCaseProtocol {
	
	
	
	
	var switchAppearence: Bool = false
	var logout: Bool = false
	var userIsVerified: Bool = false
	var showAlertDidShow: Bool = false
	var didnNavigateToSimulation: Bool = false
	
	func getUser() -> AnyPublisher<User, PersistenceError> {
		return Future<User, PersistenceError> { [weak self] promise in
			guard let self = self else { return }
			promise(.success(User(name: "Olla", isVerified: self.userIsVerified)))
		}
		.eraseToAnyPublisher()
	}
	
	func getPayments() -> AnyPublisher<Payments, PersistenceError> {
		return Future<Payments, PersistenceError> { promise in
			promise(.success(Payments(balance: 0, inProcessBalance: 0)))
		}
		.eraseToAnyPublisher()
	}
	
	func getBanners() -> AnyPublisher<[String], PersistenceError> {
		return Future<[String], PersistenceError> { promise in
			promise(.success(["", ""]))
		}
		.eraseToAnyPublisher()
	}
	
	func isDarkModeOn() -> Bool {
		return false
	}
	
	func switchAppearence(to: UIUserInterfaceStyle) {
		self.switchAppearence = to == .dark
	}
	
	func getVersion() -> String {
		return "1.0.1"
	}
	
	func doLogout() {
		logout = true
	}
	
	func showAlert(firstCompletion: @escaping (() -> Void), secondCompletion: @escaping (() -> Void)) {
		showAlertDidShow = true
	}
	
	func goToSimulation() {
		didnNavigateToSimulation = true
	}
	
}
