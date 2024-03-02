//
//  ProfileMenuCell.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

internal final class ProfileMenuCell: UITableViewCell {
	internal let cancellables = CancelBag()
	internal var menuDidTapPublisher = PassthroughSubject<ProfileVM.ActionType, Never>()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		setupLayout()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		menuDidTapPublisher = PassthroughSubject<ProfileVM.ActionType, Never>()
		contentStacView.arrangedSubviews.forEach { $0.removeFromSuperview() }
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
	
	private let contentSectionLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = .label
		return label
	}()
	
	private lazy var contentStacView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		stack.spacing = Constants.contentSpacing
		let padding = Constants.padding
		stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
		return stack
	}()
	
	private func setupLayout() {
		backgroundColor = .clear
		
		contentView.addSubview(contentSectionLabel)
		contentSectionLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(Constants.cellPadding)
			make.left.right.equalToSuperview().inset(Constants.cellPadding)
		}
		
		contentView.addSubview(contentBackgroundView)
		contentBackgroundView.snp.makeConstraints { make in
			make.top.equalTo(contentSectionLabel.snp.bottom).offset(Constants.cellPadding / 2)
			make.bottom.equalToSuperview().inset(Constants.cellPadding / 2)
			make.left.right.equalToSuperview().inset(Constants.cellPadding)
		}
		
		contentBackgroundView.addSubview(contentStacView)
		contentStacView.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(Constants.padding)
		}
	}
	
	private func setupMenu(index: Int, menu: ProfileVM.MenuDataSourceType) {
		let menuWrapperView = UIView()
		
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "lanyardcard")
		imageView.tintColor = .label
		imageView.contentMode = .scaleAspectFit
		
		let titleLabel = UILabel()
		titleLabel.font = .systemFont(ofSize: 15, weight: .regular)
		titleLabel.textColor = .label
		titleLabel.text = menu.title
		
		[imageView, titleLabel].forEach { menuWrapperView.addSubview($0) }
		imageView.snp.makeConstraints { make in
			make.size.equalTo(20)
			make.centerY.equalToSuperview()
			make.left.equalToSuperview()
		}
		
		titleLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.equalTo(imageView.snp.right).offset(Constants.contentSpacing)
		}
		
		if index > 0 {
			let divider = UIView()
			divider.backgroundColor = .label
			divider.layer.cornerRadius = 0.5
			contentStacView.addArrangedSubview(divider)
			divider.snp.makeConstraints { make in
				make.height.equalTo(1)
				make.width.equalToSuperview()
			}
		}
		
		if case .chevronButton = menu.valueType {
			let chevronButton = UIButton()
			chevronButton.isUserInteractionEnabled = false
			chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
			chevronButton.tintColor = .label
			
			menuWrapperView.addSubview(chevronButton)
			chevronButton.snp.makeConstraints { make in
				make.centerY.equalToSuperview()
				make.right.equalToSuperview()
				make.width.equalTo(10)
				make.height.equalTo(15)
			}
			
			menuWrapperView.canBeTapPublisher
				.sink { [weak self] _ in
					self?.menuDidTapPublisher.send(.default(menu))
				}
				.store(in: cancellables)
		}
		
		if case .switchButton = menu.valueType, case let .darkMode(isOn) = menu {
			let switchButton = UISwitch()
			switchButton.onTintColor = .systemGreen
			switchButton.thumbTintColor = .systemGray6
			switchButton.isOn = isOn
			
			menuWrapperView.addSubview(switchButton)
			switchButton.snp.makeConstraints { make in
				make.centerY.equalToSuperview()
				make.right.equalToSuperview()
			}
			
			switchButton.isOnPublisher
				.sink { [weak self] isOn in
					self?.menuDidTapPublisher.send(.switch(menu, isOn))
				}
				.store(in: cancellables)
		}
		
		if case .text = menu.valueType, case let .version(version) = menu {
			let titleLabel = UILabel()
			titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
			titleLabel.textColor = .label
			titleLabel.text = version
			titleLabel.textAlignment = .right
			
			menuWrapperView.addSubview(titleLabel)
			titleLabel.snp.makeConstraints { make in
				make.centerY.equalToSuperview()
				make.right.equalToSuperview()
			}
		}
		
		if case .none = menu.valueType {
			menuWrapperView.canBeTapPublisher
				.sink { [weak self] _ in
					self?.menuDidTapPublisher.send(.default(menu))
				}
				.store(in: cancellables)
		}
		
		contentStacView.addArrangedSubview(menuWrapperView)
		menuWrapperView.snp.makeConstraints { make in
			make.height.equalTo(30)
		}
	}
}

extension ProfileMenuCell {
	internal func set(title: String) {
		contentSectionLabel.text = title
	}
	
	internal func set(items: [ProfileVM.MenuDataSourceType]) {
		items.enumerated().forEach { (index, menu) in
			setupMenu(index: index, menu: menu)
		}
	}
}
