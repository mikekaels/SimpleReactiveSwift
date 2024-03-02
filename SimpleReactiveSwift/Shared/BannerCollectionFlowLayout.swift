//
//  BannerCollectionFlowLayout.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

internal final class BannerCollectionFlowLayout: UICollectionViewFlowLayout {
	init(isFull: Bool) {
		super.init()
		let fullWidth = UIScreen.main.bounds.size.width - Constants.cellPadding * 2
		minimumLineSpacing = Constants.cellPadding
		itemSize = CGSize(width: isFull ? fullWidth * (1 - Constants.bannerVisibleWidht) : fullWidth, height: 100)
		scrollDirection = .horizontal
		sectionInset = UIEdgeInsets(top: 0, left: Constants.cellPadding, bottom: 0, right: Constants.cellPadding)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
		
		let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
		
		guard let layoutAttributes = super.layoutAttributesForElements(in: targetRect) else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
		
		var offsetAdjustment = CGFloat.greatestFiniteMagnitude
		let horizontalCenter = proposedContentOffset.x + collectionView.bounds.width / 2
		
		for layoutAttribute in layoutAttributes {
			let itemHorizontalCenter = layoutAttribute.center.x
			
			let adjustedOffset = itemHorizontalCenter - horizontalCenter
			if abs(adjustedOffset) < abs(offsetAdjustment) {
				offsetAdjustment = adjustedOffset
			}
		}
		
		return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
	}
}

