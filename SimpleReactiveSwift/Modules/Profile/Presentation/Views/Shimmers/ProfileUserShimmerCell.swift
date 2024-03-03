//
//  ProfileUserShimmerCell.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

internal final class ProfileUserShimmerCell: UITableViewCell {
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
	
	private let contentAvatarView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.borderWidth = 1
		imageView.layer.cornerRadius = 30
		imageView.layer.borderColor = UIColor.systemGray6.cgColor
		imageView.backgroundColor = .systemGray5
		return imageView
	}()
	
	private let contentNameShimmer: UIView = {
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
		
		contentBackgroundView.addSubview(contentAvatarView)
		contentAvatarView.snp.makeConstraints { make in
			make.size.equalTo(60)
			make.top.left.equalToSuperview().offset(Constants.padding)
			make.bottom.equalToSuperview().inset(Constants.padding)
		}
		
		contentBackgroundView.addSubview(contentNameShimmer)
		contentNameShimmer.snp.makeConstraints { make in
			make.centerY.equalTo(contentAvatarView)
			make.left.equalTo(contentAvatarView.snp.right).offset(Constants.padding)
			make.right.equalToSuperview().inset(Constants.contentSpacing)
			make.height.equalTo(20)
		}
	}
}
