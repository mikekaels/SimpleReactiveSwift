//
//  PersistenceError.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Foundation

internal enum PersistenceError: Error {
	case fileNotFound
	case decodingError
	case encodingError
}
