//
//  UIView+TapPublisher.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit
import Combine

extension UIView {
	var tapPublisher: AnyPublisher<Void, Never> {
		let tapGestureRecognizer = UITapGestureRecognizer()
		self.addGestureRecognizer(tapGestureRecognizer)
		self.isUserInteractionEnabled = true
		
		return tapGestureRecognizer.tapPublisher
			.map { _ in () }
			.eraseToAnyPublisher()
	}
}
