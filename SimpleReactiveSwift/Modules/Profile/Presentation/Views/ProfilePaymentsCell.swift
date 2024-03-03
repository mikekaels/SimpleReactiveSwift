//
//  ProfilePaymentsCell.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit
import SnapKit
import Combine

internal final class ProfilePaymentCell: UITableViewCell {
	internal let cancellables = CancelBag()
	internal var balanceInProgressTappedPublisher = PassthroughSubject<Void, Never>()
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		setupLayout()
		bindView()
		
		registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
			self.balanceinProcessStackView.layer.borderColor = UIColor.dynamicColor.cgColor
		})
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		balanceInProgressTappedPublisher = PassthroughSubject<Void, Never>()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let contentBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .secondarySystemGroupedBackground
		view.layer.cornerRadius = Constants.cellPadding - 8
		return view
	}()
	
	private let contentBalanceLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16)
		label.textColor = .dynamicColor
		label.text = "Balance"
		return label
	}()
	
	private let contentBalanceValueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .bold)
		label.textColor = .dynamicColor
		return label
	}()
	
	private lazy var contentStacView: UIStackView = {
		let stack = UIStackView()
		stack.addArrangedSubview(contentBalanceLabel)
		stack.addArrangedSubview(contentBalanceValueLabel)
		stack.axis = .vertical
		stack.spacing = Constants.contentSpacing
		return stack
	}()
	
	private lazy var balanceInProcessLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.textColor = .dynamicColor
		label.text = "Balance in process"
		return label
	}()
	
	private lazy var balanceInProcessValueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .semibold)
		label.textColor = .dynamicColor
		label.text = "Rp 20.000"
		return label
	}()
	
	private lazy var chevronButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		button.tintColor = .dynamicColor
		button.isUserInteractionEnabled = false
		return button
	}()
	
	private lazy var balanceinProcessStackView: UIStackView = {
		let stack = UIStackView()
		stack.addArrangedSubview(balanceInProcessLabel)
		stack.addArrangedSubview(balanceInProcessValueLabel)
		stack.addArrangedSubview(chevronButton)
		stack.spacing = Constants.contentSpacing
		stack.axis = .horizontal
		stack.alignment = .center
		stack.distribution = .fill
		stack.layer.borderWidth = 1
		stack.layer.cornerRadius = Constants.cornerRadius
		stack.layer.borderColor = UIColor.dynamicColor.cgColor
		let padding = Constants.padding / 2
		stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: padding, leading: padding * 1.5, bottom: padding, trailing: padding * 1.5)
		stack.isLayoutMarginsRelativeArrangement = true
		return stack
	}()
	
	private func setupLayout() {
		backgroundColor = .clear
		contentView.addSubview(contentBackgroundView)
		contentBackgroundView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(Constants.cellPadding / 2)
			make.left.right.equalToSuperview().inset(Constants.cellPadding)
		}
		
		contentBackgroundView.addSubview(contentStacView)
		contentStacView.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(Constants.padding)
		}
	}
	
	private func bindView() {
		balanceinProcessStackView.canBeTapPublisher
			.sink { [weak self] _ in
				self?.balanceInProgressTappedPublisher.send(())
			}
			.store(in: cancellables)
	}
}

extension ProfilePaymentCell {
	internal func set(balance: Int) {
		contentBalanceValueLabel.text = "Rp \(balance.toDecimalString())"
	}
	
	internal func set(balanceInProcess: Int) {
		guard balanceInProcess > 0 else { return }
		let balanceString = balanceInProcess.toDecimalString()
		balanceInProcessValueLabel.text = "Rp \(balanceString)"
		
		contentStacView.addArrangedSubview(balanceinProcessStackView)
		balanceinProcessStackView.snp.makeConstraints { make in
			make.height.equalTo(35)
		}
		contentStacView.setCustomSpacing(Constants.contentSpacing * 1.5, after: contentBalanceValueLabel)
		chevronButton.snp.makeConstraints { make in
			make.width.equalTo(10)
			make.height.equalTo(15)
		}
	}
}
