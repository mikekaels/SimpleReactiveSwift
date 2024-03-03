//
//  ProfilePaymentsShimmerCell.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import UIKit
import SnapKit

internal final class ProfilePaymentShimmerCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		setupLayout()
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
	
	private let contentBalanceValueShimmerView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemGray5
		return view
	}()
	
	private lazy var contentStacView: UIStackView = {
		let stack = UIStackView()
		stack.alignment = .leading
		stack.distribution = .fill
		stack.addArrangedSubview(contentBalanceLabel)
		stack.addArrangedSubview(contentBalanceValueShimmerView)
		stack.addArrangedSubview(balanceInProcessShimmerView)
		stack.axis = .vertical
		stack.spacing = Constants.contentSpacing
		return stack
	}()
	
	private lazy var balanceInProcessShimmerView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemGray5
		return view
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
		
		contentBalanceValueShimmerView.snp.makeConstraints { make in
			make.height.equalTo(20)
			make.width.equalToSuperview().multipliedBy(0.5)
		}
		
		balanceInProcessShimmerView.snp.makeConstraints { make in
			make.height.equalTo(30)
			make.width.equalToSuperview()
		}
		
		contentStacView.setCustomSpacing(10, after: contentBalanceValueShimmerView)
	}
}
