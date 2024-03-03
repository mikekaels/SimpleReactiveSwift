//
//  ProfileSectionDataSourceType.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import Foundation

enum ProfileSectionDataSourceType: Hashable {
	case userSection(ProfileStateType<User>)
	case paymentsSection(ProfileStateType<Payments>)
	case bannersSection(ProfileStateType<[String]>)
	case defaultMenuSection(title: String, items: [ProfileMenuDataSourceType])
}

enum ProfileMenuDataSourceType: Hashable {
	case referral
	case invitation
	case notification
	case darkMode(Bool)
	case version(String)
	case legal
	case logout
	case `default`
	
	var title: String {
		switch self {
		case .referral: return "Reverral"
		case .invitation: return"Invitation"
		case .notification: return "Notification"
		case .darkMode: return "Dark Mode"
		case .version: return "Version"
		case .legal: return "Legal"
		case .logout: return "Logout"
		default: return ""
		}
	}
	
	var valueType: MenuValueType {
		switch self {
		case .referral: return .chevronButton
		case .invitation: return .chevronButton
		case .notification: return .chevronButton
		case .darkMode: return .switchButton
		case .version: return .text
		case .legal: return .chevronButton
		case .logout: return .none
		default: return .none
		}
	}
	
	enum MenuValueType {
		case chevronButton
		case switchButton
		case text
		case none
	}
}

