//
//  ProfileVC.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit

internal final class ProfileVC: UIViewController {
	let viewModel: ProfileVM
	
	init(viewModel: ProfileVM = ProfileVM()) {
		self.viewModel = viewModel
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
