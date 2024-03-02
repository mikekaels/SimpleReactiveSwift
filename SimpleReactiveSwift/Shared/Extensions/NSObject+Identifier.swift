//
//  NSObject+Identifier.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Foundation

extension NSObject {
	public var identifier: String {
		String(describing: type(of: self))
	}
	
	public static var identifier: String {
		String(describing: self)
	}
}
