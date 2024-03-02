//
//  ProfileBannersCell.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit
import SnapKit

internal final class ProfileBannersCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
		collection.backgroundColor = .clear
		collection.showsHorizontalScrollIndicator = false
		
		collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
		return collection
	}()
	
	private lazy var dataSource: UICollectionViewDiffableDataSource<String, String> = {
		let dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView) { [weak self] collectionView, indexPath, color in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.identifier, for: indexPath)
			cell.backgroundColor = UIColor(hex: color)
			cell.layer.cornerRadius = Constants.cornerRadius
			return cell
		}
		return dataSource
	}()
	
	private func setupLayout() {
		backgroundColor = .clear
		contentView.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.height.equalTo(120)
		}
	}
}

extension ProfileBannersCell {
	internal func set(banners: [String]) {
		setupCollectionLayout(isFull: banners.count > 1)
		var snapshoot = NSDiffableDataSourceSnapshot<String, String>()
		snapshoot.appendSections(["main"])
		snapshoot.appendItems(banners, toSection: "main")
		self.dataSource.apply(snapshoot, animatingDifferences: true)
	}
	
	private func setupCollectionLayout(isFull: Bool) {
		let layout = BannerCollectionFlowLayout(isFull: isFull)
		collectionView.collectionViewLayout = layout
		collectionView.reloadData()
	}
}
