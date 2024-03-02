//
//  SimulationVC.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

internal final class SimulationVC: UIStackViewController {
	private let viewModel: SimulationVM
	private let cancellables = CancelBag()
	private let estReturnDidTapPublisher = PassthroughSubject<SimulationVM.ESTReturnType, Never>()
	private let didLoadPublisher = PassthroughSubject<Void, Never>()
	
	init(viewModel: SimulationVM = SimulationVM()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
		bindViewModel()
	}
	
	private let marketPriceTextfieldWrapperView: TextFieldWrapperView = {
		let view = TextFieldWrapperView()
		
		// Label
		view.label.text = "Market Price"
		view.label.font = .systemFont(ofSize: 16, weight: .regular)
		view.label.textColor = .label
		
		let currencyView = UILabel()
		currencyView.text = "  Rp "
		currencyView.textColor = .label
		
		// Textfield
		view.textField.placeholder = "Market Price"
		view.textField.keyboardType = .numberPad
		
		view.setLeft(view: currencyView)
		return view
	}()
	
	private let yearlyProjectionTextfieldWrapperView: TextFieldWrapperView = {
		let view = TextFieldWrapperView()
		
		// Label
		view.label.text = "Yearly Projection"
		view.label.font = .systemFont(ofSize: 16, weight: .regular)
		view.label.textColor = .label
		
		let percentView = UILabel()
		percentView.text = " %  "
		percentView.textColor = .label
		
		// Textfield
		view.textField.placeholder = "Yearly Projection"
		view.textField.keyboardType = .numberPad
		view.textField.isEnabled = false
		view.textField.backgroundColor = .tertiarySystemFill
		
		view.setRight(view: percentView)
		return view
	}()
	
	private let investmentUnitTextfieldWrapperView: TextFieldWrapperView = {
		let view = TextFieldWrapperView()
		
		// Label
		view.label.text = "Investment Unit"
		view.label.font = .systemFont(ofSize: 16, weight: .regular)
		view.label.textColor = .label
		
		let qtyView = UILabel()
		qtyView.text = " Qty  "
		qtyView.textColor = .label
		
		// Textfield
		view.textField.placeholder =  "Investment Unit"
		view.textField.keyboardType = .numberPad
		view.textField.isEnabled = false
		view.textField.backgroundColor = .tertiarySystemFill
		
		view.setRight(view: qtyView)
		return view
	}()
	
	private lazy var yearlyAndIvestmentStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		stack.spacing = Constants.contentSpacing
		
		stack.addArrangedSubview(yearlyProjectionTextfieldWrapperView)
		stack.addArrangedSubview(investmentUnitTextfieldWrapperView)
		return stack
	}()
	
	internal let estReturnLabel = {
		let label = UILabel()
		label.text = "Est return:"
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.textColor = .label
		return label
	}()
	
	private let estReturnButtonView: UIMultipleSelectButton = {
		let view = UIMultipleSelectButton<SimulationVM.ESTReturnType>()
		view.axis = .horizontal
		view.distribution = .fillEqually
		view.spacing = Constants.contentSpacing
		
		return view
	}()
	
	private lazy var totalInvestmentTextfieldWrapperView: TextFieldWrapperView = {
		let view = TextFieldWrapperView()
		
		// Label
		view.label.text = "Total investment"
		view.label.font = .systemFont(ofSize: 16, weight: .regular)
		view.label.textColor = .label
		
		let currencyView = UILabel()
		currencyView.text = "  Rp "
		currencyView.textColor = .label
		
		// Textfield
		view.textField.placeholder =  "Total investment"
		view.textField.keyboardType = .numberPad
		view.textField.isEnabled = false
		view.textField.backgroundColor = .tertiarySystemFill
		
		view.setLeft(view: currencyView)
		
		// pre sub label
		view.preSubLabelAttributed.isHidden = false
		view.preSubLabelAttributed.font = .systemFont(ofSize: 12)
		view.preSubLabelAttributed.textColor = .dynamicColor
		view.preSubLabelAttributed.numberOfLines = 0
		
		// pra sub label
		view.praSubLabelAttributed.isHidden = false
		view.praSubLabelAttributed.font = .systemFont(ofSize: 12)
		view.praSubLabelAttributed.textColor = .systemGreen
		view.praSubLabelAttributed.numberOfLines = 0
		view.praSubLabelAttributed.text = "ROI: RP 64.000"
		return view
	}()
	
	private func bindViewModel() {
		let action = SimulationVM.Action(didLoad: Just(()).eraseToAnyPublisher(),
										 marketPriceDidChange: marketPriceTextfieldWrapperView.textField.textPublisher.eraseToAnyPublisher(),
										 estReturnDidChange: estReturnButtonView.didTapPublisher.eraseToAnyPublisher()
		)
		
		let state = viewModel.transform(action, cancellables)
		
		state.$estReturns
			.receive(on: DispatchQueue.main)
			.sink { [weak self] estReturns in
				self?.estReturnButtonView.items = estReturns
			}
			.store(in: cancellables)
		
		state.$marketPrice
			.receive(on: DispatchQueue.main)
			.sink { [weak self] marketPrice in
				self?.marketPriceTextfieldWrapperView.textField.text = marketPrice.toDecimalString()
			}
			.store(in: cancellables)
		
		state.$qtyOwned
			.receive(on: DispatchQueue.main)
			.sink { [weak self] qtyOwned in
				self?.investmentUnitTextfieldWrapperView.textField.text = qtyOwned.toDecimalString()
			}
			.store(in: cancellables)
		
		state.$yearlyProjection
			.receive(on: DispatchQueue.main)
			.sink { [weak self] yearlyProjection in
				let formated = 100 * yearlyProjection
				self?.yearlyProjectionTextfieldWrapperView.textField.text = formated.toDecimalString()
			}
			.store(in: cancellables)
		
		state.$totalInvestment
			.receive(on: DispatchQueue.main)
			.sink { [weak self] totalInvestment in
				self?.totalInvestmentTextfieldWrapperView.textField.text = totalInvestment.toDecimalString()
			}
			.store(in: cancellables)
		
		Publishers.CombineLatest(state.$investmentDateFrom, state.$investmentDateTo)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] (fromDate, toDate) in
				self?.totalInvestmentTextfieldWrapperView.preSubLabelAttributed.text = "from \(fromDate) to \(toDate)"
				self?.totalInvestmentTextfieldWrapperView.preSubLabelAttributed.attributedStrings = [
					.colored(text: fromDate, color: .systemGreen),
					.font(text: fromDate, font: .systemFont(ofSize: 12, weight: .medium)),
					.colored(text: toDate, color: .systemGreen),
					.font(text: toDate, font: .systemFont(ofSize: 12, weight: .medium)),
				]
			}
			.store(in: cancellables)
	}
	
	private func setupLayout() {
		view.backgroundColor = .systemBackground
		contentView.spacing = 20
		contentView.alignment = .leading
		
		contentView.snp.updateConstraints { make in
			make.top.equalToSuperview().offset(32)
		}
		
		contentView.snp.makeConstraints { make in
			make.width.equalToSuperview().offset(-Constants.cellPadding * 2)
			make.centerX.equalToSuperview()
		}
		
		[
			marketPriceTextfieldWrapperView,
			yearlyAndIvestmentStack,
			estReturnLabel,
			estReturnButtonView,
			totalInvestmentTextfieldWrapperView,
		].forEach {
			contentView.addArrangedSubview($0)
			$0.snp.makeConstraints { make in
				make.width.equalToSuperview()
			}
		}
		
		contentView.setCustomSpacing(Constants.contentSpacing, after: estReturnLabel)
		contentView.setCustomSpacing(30, after: estReturnButtonView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
