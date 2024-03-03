//
//  ESTReturnType.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Foundation

enum ESTReturnType: HasTitle {
	case sixMonth
	case oneYear
	case threeYear
	case fiveYear
	
	var title: String {
		switch self {
		case .sixMonth: return "6M"
		case .oneYear: return "1Y"
		case .threeYear: return "3Y"
		case .fiveYear: return "5Y"
		}
	}
	
	var value: Double {
		switch self {
		case .sixMonth: return 0.5
		case .oneYear: return 1
		case .threeYear: return 3
		case .fiveYear: return 5
		}
	}
	
	var initialSelectedState: Bool {
		switch self {
		case .sixMonth: return false
		case .oneYear: return false
		case .threeYear: return false
		case .fiveYear: return true
		}
	}
	}
