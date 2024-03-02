//
//  String+toDouble.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Foundation

extension String {
	internal func toDouble() -> Double {
		let trimmed = self.replacingOccurrences(of: ".", with: "")
			.replacingOccurrences(of: ",", with: ".")
		return Double(trimmed) ?? 0.0
	}
}

