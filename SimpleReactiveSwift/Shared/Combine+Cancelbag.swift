//
//  Combine+Cancelbag.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 02/03/24.
//

import Combine

/// A class for managing cancellable subscriptions.
internal final class CancelBag {
	/// A set containing the cancellable subscriptions.
	internal var subscriptions = Set<AnyCancellable>()
	
	/// Cancels all subscriptions and removes them from the bag.
	internal func cancel() {
		subscriptions.forEach { $0.cancel() }
		subscriptions.removeAll()
	}
	
	/// Initializes a new instance of `CancelBag`.
	internal init() {}
}

extension AnyCancellable {
	/// Stores the subscription in the specified `CancelBag`.
	///
	/// - Parameter cancelBag: The `CancelBag` to store the subscription in.
	internal func store(in cancelBag: CancelBag) {
		cancelBag.subscriptions.insert(self)
	}
}

