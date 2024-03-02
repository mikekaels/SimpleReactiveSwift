//
//  String+ToSimpleDateString.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Foundation

extension String {
	internal func toSimpleDateString() -> String {
		// Create a DateFormatter instance
		let dateFormatter = DateFormatter()
		
		// Set the input date format
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		
		// Parse the input string into a Date object
		guard let date = dateFormatter.date(from: self) else {
			return "" // Return nil if the input string is not in the expected format
		}
		
		// Set the output date format
		dateFormatter.dateFormat = "d MMM yyyy"
		
		// Format the Date object into the desired output string format
		let formattedString = dateFormatter.string(from: date)
		
		return formattedString
	}
}
