//
//  String+CalculateNMonthsLater.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Foundation

extension String {
	internal func calculateMonthsLater(n: Int) -> String? {
		// Create a DateFormatter instance
		let dateFormatter = DateFormatter()
		
		// Set the input date format
		dateFormatter.dateFormat = "d MMM yyyy"
		
		// Parse the input string into a Date object
		guard let date = dateFormatter.date(from: self) else {
			return nil // Return nil if the input string is not in the expected format
		}
		
		// Create a Calendar instance
		var calendar = Calendar.current
		
		// Add 60 months to the date
		if let futureDate = calendar.date(byAdding: .month, value: n, to: date) {
			// Format the future date into the desired output string format
			dateFormatter.dateFormat = "d MMM yyyy"
			let formattedString = dateFormatter.string(from: futureDate)
			return formattedString
		} else {
			return nil // Return nil if the future date calculation fails
		}
	}
}
