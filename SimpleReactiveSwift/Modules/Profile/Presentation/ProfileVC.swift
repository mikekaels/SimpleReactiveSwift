//
//  ProfileVC.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit
import Combine
import SnapKit

internal final class ProfileVC: UIViewController {
	private let viewModel: ProfileVM
	private let cancellables = CancelBag()
	private let didLoadPublisher = PassthroughSubject<Void, Never>()
	private let menuDidTapPublisher = PassthroughSubject<ProfileVM.ActionType, Never>()
	
	init(viewModel: ProfileVM = ProfileVM()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
		bindViewModel()
		didLoadPublisher.send(())
	}
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.backgroundColor = .clear
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		tableView.register(ProfileUserCell.self, forCellReuseIdentifier: ProfileUserCell.identifier)
		
		tableView.register(ProfileUserShimmerCell.self, forCellReuseIdentifier: ProfileUserShimmerCell.identifier)
		
		tableView.register(ProfilePaymentCell.self, forCellReuseIdentifier: ProfilePaymentCell.identifier)
		
		tableView.register(ProfileBannersCell.self, forCellReuseIdentifier: ProfileBannersCell.identifier)
		
		tableView.register(ProfileMenuCell.self, forCellReuseIdentifier: ProfileMenuCell.identifier)
		return tableView
	}()
	
	private lazy var dataSource: UITableViewDiffableDataSource<ProfileVM.Section, ProfileVM.SectionDataSourceType> = {
		let dataSource = UITableViewDiffableDataSource<ProfileVM.Section, ProfileVM.SectionDataSourceType>(tableView: tableView) { [weak self] tableView, indexPath, type in
			
			if case .userSection(.loading) = type, let cell = tableView.dequeueReusableCell(withIdentifier: ProfileUserShimmerCell.identifier, for: indexPath) as? ProfileUserShimmerCell {
				return cell
			}
			
			if case let .userSection(.content(user)) = type, let cell = tableView.dequeueReusableCell(withIdentifier: ProfileUserCell.identifier, for: indexPath) as? ProfileUserCell {
				cell.set(name: user.name)
				return cell
			}
			
			if case let .paymentsSection(.content(payment)) = type, let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePaymentCell.identifier, for: indexPath) as? ProfilePaymentCell {
				cell.set(balance: payment.balance)
				cell.set(balanceInProcess: payment.inProcessBalance)
				return cell
			}
			
			if case let .bannersSection(.content(banners)) = type, let cell = tableView.dequeueReusableCell(withIdentifier: ProfileBannersCell.identifier, for: indexPath) as? ProfileBannersCell {
				cell.set(banners: banners)
				return cell
			}
			
			if case let .defaultMenuSection(title, items) = type, let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMenuCell.identifier, for: indexPath) as? ProfileMenuCell {
				cell.set(title: title)
				cell.set(items: items)
				
				cell.menuDidTapPublisher
					.sink { [weak self] actionType in
						self?.menuDidTapPublisher.send(actionType)
					}
					.store(in: cell.cancellables)
				return cell
			}
		
			return UITableViewCell()
		}
		
		dataSource.defaultRowAnimation = .fade
		return dataSource
	}()
	
	private func bindViewModel() {
		let action = ProfileVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
									  menuDidTap: menuDidTapPublisher.eraseToAnyPublisher()
		)
		
		let state = viewModel.transform(action, cancellables)
		
		state.$dataSources
			.receive(on: DispatchQueue.main)
			.sink { [weak self] contents in
				guard let self = self else { return }
				var snapshot = NSDiffableDataSourceSnapshot<ProfileVM.Section, ProfileVM.SectionDataSourceType>()
				snapshot.appendSections([.main])
				snapshot.appendItems(contents, toSection: .main)
				self.dataSource.apply(snapshot, animatingDifferences: true)
			}
			.store(in: cancellables)
	}
	
	private func setupLayout() {
		view.backgroundColor = .systemGroupedBackground
		view.addSubview(tableView)
		
		tableView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
