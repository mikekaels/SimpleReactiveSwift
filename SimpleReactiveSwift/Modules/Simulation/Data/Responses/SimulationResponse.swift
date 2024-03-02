//
//  SimulationResponse.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Foundation

internal struct SimulationResponse: Codable {
	let yearlyProjection: Double?
	let investmentDate: String?
	let qtyOwned: String?
	let marketPrice: String?
	
	enum CodingKeys: String, CodingKey {
		case yearlyProjection = "yearly_projection"
		case investmentDate = "investment_date"
		case qtyOwned = "qty_owned"
		case marketPrice = "market_price"
	}
}

extension SimulationResponse {
	func toDomain() -> Simulation {
		Simulation(yearlyProjection: yearlyProjection ?? 0.0, investmentDate: investmentDate ?? "", qtyOwned: qtyOwned?.toDouble() ?? 0.0, marketPrice: marketPrice?.toDouble() ?? 0.0)
	}
}
