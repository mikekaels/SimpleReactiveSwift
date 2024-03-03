//
//  MockPersistenceManager.swift
//  SimpleReactiveSwiftTests
//
//  Created by Santo Michael on 03/03/24.
//

import Foundation

@testable import SimpleReactiveSwift
class MockFailedPersistenceManager: PersistenceManagerProtocol {
	func loadObject<T: Decodable>(from fileName: String) throws -> T {
		throw PersistenceError.fileNotFound
	}
}

class MockSuccessPersistenceManager: PersistenceManagerProtocol {
	let userResponse: UserResponse<UserDataResponse>
	let paymentsResponse: PaymentsResponse<PaymentsDataResponse>
	let bannersResponse: BannersDataResponse
	let simulationResponse: SimulationResponse
	
	init(userResponse: UserResponse<UserDataResponse> = UserResponse(user: UserDataResponse(name: "Magician", isVerified: true)),
		 paymentResponse: PaymentsResponse<PaymentsDataResponse> = PaymentsResponse(payments: PaymentsDataResponse(balance: 1, inProcessBalance: 2)),
		 bannersResponse: BannersDataResponse = BannersDataResponse(banners: ["ban", "ner"]),
		 simulationResponse: SimulationResponse = SimulationResponse(yearlyProjection: 1.0, investmentDate: "2023-11-05T12:08:56+07:00", qtyOwned: "1", marketPrice: "1")
	) {
		self.userResponse = userResponse
		self.paymentsResponse = paymentResponse
		self.bannersResponse = bannersResponse
		self.simulationResponse = simulationResponse
	}
	
	func loadObject<T>(from key: String) throws -> T where T : Decodable, T : Encodable {
		switch key {
		case "USER":
			return userResponse as! T
		case "PAYMENTS":
			return paymentsResponse as! T
		case "BANNERS":
			return bannersResponse as! T
		case "SIMULATION":
			return simulationResponse as! T
		default:
			fatalError("Unknown key")
		}
	}
}


