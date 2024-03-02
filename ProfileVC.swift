//
//  ProfileVC.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

internal final class ProfileVC: UIViewController {
	init() {
		super.init(nibName: nil, bundle: nil)
		view.backgroundColor = .red
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
	}
	
	private func setupLayout() {
		
	}
}
