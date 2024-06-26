//
//  UIColor+hex.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

extension UIColor {
	internal static let dynamicColor = UIColor { traitCollection in
		return UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle == .dark ? .white : .black
	}
	
	internal convenience init(hex: String) {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 1
		
		let hexColor = hex.replacingOccurrences(of: "#", with: "")
		let scanner = Scanner(string: hexColor)
		var hexNumber: UInt64 = 0
		var valid = false
		
		if scanner.scanHexInt64(&hexNumber) {
			if hexColor.count == 8 {
				r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
				g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
				b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
				a = CGFloat(hexNumber & 0x000000ff) / 255
				valid = true
			}
			else if hexColor.count == 6 {
				r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
				g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
				b = CGFloat(hexNumber & 0x0000ff) / 255
				valid = true
			}
		}
		
		#if DEBUG
		assert(valid, "UIColor initialized with invalid hex string")
		#endif
		
		self.init(red: r, green: g, blue: b, alpha: a)
	}
}
