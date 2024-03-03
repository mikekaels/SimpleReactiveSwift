//
//  ProfileStateType.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Foundation

enum ProfileStateType<T: Hashable>: Hashable {
	case loading
	case content(T)
}
