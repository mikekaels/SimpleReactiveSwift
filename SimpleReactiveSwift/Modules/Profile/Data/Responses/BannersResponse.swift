//
//  BannersResponse.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Foundation

internal struct BannersDataResponse: Codable {
	let banners: [String]?
}

extension BannersDataResponse {
	func toDomain() -> [String] {
		return banners?.compactMap { $0 } ?? []
	}
}
