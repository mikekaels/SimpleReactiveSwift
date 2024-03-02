//
//  UIStackViewController.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

public class UIStackViewController: UIViewController {
	
	public lazy var contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = .fill
		stackView.axis = .vertical
		return stackView
	}()
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.addSubview(contentView)
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
	
	public var showsVerticalScrollIndicator: Bool = false {
		didSet {
			scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
		}
	}
	
	public var showsHorizontalScrollIndicator: Bool = false {
		didSet {
			scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
		}
	}
	
	public var isScrollEnabled: Bool = true {
		didSet {
			scrollView.isScrollEnabled = isScrollEnabled
		}
	}
	
	public override func loadView() {
		let containerView = UIView()
		
		containerView.addSubview(scrollView)
		
		scrollView.snp.makeConstraints { make in
			make.right.left.top.bottom.equalToSuperview()
		}
		
		contentView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.bottom.lessThanOrEqualToSuperview()
		}
		
		self.view = containerView
	}
}

