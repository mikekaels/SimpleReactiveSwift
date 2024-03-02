//
//  PersistenceManager.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Foundation

internal class PersistenceManager {
	func loadObject<T: Codable>(from fileName: String) throws -> T {
		
		guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
			throw PersistenceError.fileNotFound
		}
		
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path))
			let object = try JSONDecoder().decode(T.self, from: data)
			return object
		} catch {
			throw PersistenceError.decodingError
		}
	}
	
	private func fileURL(_ fileName: String) -> URL {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		return documentsDirectory.appendingPathComponent(fileName)
	}
}
