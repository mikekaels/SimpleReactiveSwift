//
//  NSObject+Identifier.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Foundation

extension NSObject {
	internal var identifier: String {
		String(describing: type(of: self))
	}
	
	internal static var identifier: String {
		String(describing: self)
	}
}
