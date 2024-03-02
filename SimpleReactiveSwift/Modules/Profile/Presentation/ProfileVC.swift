//
//  ProfileVC.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit
import Combine

internal final class ProfileVC: UIViewController {
	private let viewModel: ProfileVM
	private let cancellables = CancelBag()
	private let didLoadPublisher = PassthroughSubject<Void, Never>()
	
	init(viewModel: ProfileVM = ProfileVM()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	enum Section {
		case main
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
		bindViewModel()
		didLoadPublisher.send(())
	}
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .clear
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.separatorStyle = .none
		return tableView
	}()
	
	private lazy var dataSource: UITableViewDiffableDataSource<Section, ProfileVM.DataSourceType> = {
		let dataSource = UITableViewDiffableDataSource<Section, ProfileVM.DataSourceType>(tableView: tableView) { [weak self] tableView, indexPath, type in
			
			
			return UITableViewCell()
		}
		dataSource.defaultRowAnimation = .fade
		return dataSource
	}()
	
	private func bindViewModel() {
		let action = ProfileVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher())
		let state = viewModel.transform(action, cancellables)
		
		
	}
	
	private func setupLayout() {
		view.backgroundColor = .white
	}
}
