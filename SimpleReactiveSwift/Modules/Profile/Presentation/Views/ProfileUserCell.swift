//
//  ProfileUserCell.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit
import SnapKit

internal final class ProfileUserCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		setupLayout()
		
		registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
			self.contentAvatarView.layer.borderColor = UIColor.dynamicColor.cgColor
		})
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
	
	private let contentAvatarView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.borderWidth = 1
		imageView.layer.cornerRadius = 30
		imageView.layer.borderColor = UIColor.dynamicColor.cgColor
		return imageView
	}()
	
	private let contentNameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20, weight: .bold)
		label.textColor = .dynamicColor
		return label
	}()
	
	private func setupLayout() {
		backgroundColor = .clear
		contentView.addSubview(contentBackgroundView)
		contentBackgroundView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(Constants.cellPadding / 2)
			make.left.right.equalToSuperview().inset(Constants.cellPadding)
		}
		
		contentBackgroundView.addSubview(contentAvatarView)
		contentAvatarView.snp.makeConstraints { make in
			make.size.equalTo(60)
			make.top.left.equalToSuperview().offset(Constants.padding)
			make.bottom.equalToSuperview().inset(Constants.padding)
		}
		
		contentBackgroundView.addSubview(contentNameLabel)
		contentNameLabel.snp.makeConstraints { make in
			make.centerY.equalTo(contentAvatarView)
			make.left.equalTo(contentAvatarView.snp.right).offset(Constants.padding)
			make.right.equalToSuperview().inset(Constants.contentSpacing)
		}
	}
}

extension ProfileUserCell {
	internal func set(name: String) {
		contentNameLabel.text = name
	}
}
