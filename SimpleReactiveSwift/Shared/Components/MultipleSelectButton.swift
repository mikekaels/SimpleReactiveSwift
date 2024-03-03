//
//  MultipleSelectButton.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import UIKit
import Combine

internal protocol HasTitle {
	var title: String { get }
	var initialSelectedState: Bool { get }
}

internal final class UIMultipleSelectButton<T: HasTitle>: UIStackView {
	private let cancellables = CancelBag()
	internal let didTapPublisher = PassthroughSubject<T, Never>()
	internal var items: [T] = [] {
		didSet {
			setupButtons()
		}
	}
	
	private var buttons: [UIButton] = []
	init() {
		super.init(frame: .zero)
		registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
			self.buttons.forEach {
				$0.layer.borderColor = UIColor.dynamicColor.cgColor
				$0.setTitleColor(.dynamicColor, for: .normal)
			}
		})
		setupButtons()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupButtons() {
		guard !items.isEmpty else { return }
		items.forEach { type in
			let button = UIButton()
			button.setTitle(type.title, for: .normal)
			button.setTitleColor(.dynamicColor, for: .normal)
			button.layer.cornerRadius = Constants.cornerRadius
			button.layer.borderWidth = type.initialSelectedState ? 1.5 : 1
			button.layer.borderColor = type.initialSelectedState ? UIColor.systemRed.cgColor : UIColor.dynamicColor.cgColor
			button.tintColor = .dynamicColor
			addArrangedSubview(button)
			
			buttons.append(button)
			
			button.tapPublisher
				.sink { [weak self] _ in
					self?.didTapPublisher.send(type)
					self?.buttons.forEach {
						$0.layer.borderColor = UIColor.dynamicColor.cgColor
						$0.layer.borderWidth = 1
					}
					button.layer.borderColor = UIColor.systemRed.cgColor
					button.layer.borderWidth = 1.5
				}
				.store(in: cancellables)
		}
	}
}

