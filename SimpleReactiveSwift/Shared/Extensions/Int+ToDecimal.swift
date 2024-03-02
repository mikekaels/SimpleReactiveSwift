//
//  Int+ToDecimal.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Foundation

extension Int {
	internal func toDecimalString() -> String {
		let numberFormater = NumberFormatter()
		numberFormater.numberStyle = .decimal
		let decimalString = numberFormater.string(from: NSNumber(value: self))
		return decimalString ?? ""
	}
}

extension Double {
	internal func toDecimalString() -> String {
		let numberFormater = NumberFormatter()
		numberFormater.numberStyle = .decimal
		let decimalString = numberFormater.string(from: NSNumber(value: self))
		return decimalString ?? ""
	}
}
