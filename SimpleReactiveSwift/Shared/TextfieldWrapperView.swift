//
//  TextfieldWrapperView.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

internal final class TextFieldWrapperView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
		registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
			self.textField.layer.borderColor = UIColor.dynamicColor.cgColor
		})
	}
	
	internal let stackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	internal let label = UILabel()
	
	internal let preSubLabelAttributed: UIAttributedLabel = {
		let label = UIAttributedLabel()
		
		label.font = .systemFont(ofSize: 12, weight: .regular)
		label.textColor = .dynamicColor
		label.numberOfLines = 0
		label.textAlignment = .left
		label.isHidden = true
		return label
	}()
	
	internal let praSubLabelAttributed: UIAttributedLabel = {
		let label = UIAttributedLabel()
		label.font = .systemFont(ofSize: 12, weight: .regular)
		label.textColor = .dynamicColor
		label.numberOfLines = 0
		label.textAlignment = .left

		label.isHidden = true
		return label
	}()
	
	internal let textField: UITextField = {
		let textField = UITextField()
		textField.layer.borderWidth = 1
		textField.layer.borderColor = UIColor.dynamicColor.cgColor
		textField.layer.cornerRadius = Constants.cornerRadius
		textField.backgroundColor = .systemBackground
		textField.rightViewMode = .always
		textField.leftViewMode = .always
		textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
		return textField
	}()
	
	internal func setLeft(view: UIView) {
		textField.leftView = view
	}
	
	internal func setRight(view: UIView) {
		textField.rightView = view
	}
	
	private func setupLayout() {
		textField.autocorrectionType = .no
		textField.spellCheckingType = .no
		addSubview(stackView)
		[
			label,
			preSubLabelAttributed,
			textField,
			praSubLabelAttributed
		].forEach { stackView.addArrangedSubview($0) }
		
		stackView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		textField.snp.makeConstraints { make in
			make.width.equalToSuperview()
			make.height.equalTo(44)
		}
		
		preSubLabelAttributed.snp.makeConstraints { make in
			make.width.equalToSuperview()
		}
		
		stackView.setCustomSpacing(Constants.contentSpacing / 2, after: label)
		stackView.setCustomSpacing(Constants.contentSpacing, after: preSubLabelAttributed)
		stackView.setCustomSpacing(Constants.contentSpacing, after: textField)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
