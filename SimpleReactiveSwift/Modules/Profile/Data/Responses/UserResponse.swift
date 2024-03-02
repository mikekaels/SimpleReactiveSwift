//
//  UserResponse.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Foundation

internal struct UserResponse<T: Codable>: Codable {
	let user: T?
}

internal struct UserDataResponse: Codable {
	let name: String?
	let isVerified: Bool?
	
	enum CodingKeys: String, CodingKey {
		case name
		case isVerified = "is_verified"
	}
}

extension UserDataResponse {
	func toDomain() -> User {
		User(name: name ?? "", isVerified: isVerified ?? false)
	}
}
