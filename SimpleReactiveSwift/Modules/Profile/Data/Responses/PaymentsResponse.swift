//
//  PaymentsResponse.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Foundation

internal struct PaymentsResponse<T: Codable>: Codable {
	let payments: T?
}

internal struct PaymentsDataResponse: Codable {
	let balance: Int?
	let inProcessBalance: Int?
	
	enum CodingKeys: String, CodingKey {
		case balance
		case inProcessBalance = "in_process_balance"
	}
}

extension PaymentsDataResponse {
	func toDomain() -> Payments {
		Payments(balance: balance ?? 0, inProcessBalance: inProcessBalance ?? 0)
	}
}
