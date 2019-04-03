//
//  ErrorContext.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// A class that can observe the context and respond to changes
public protocol ErrorContextObserving: class {
    /// Called when the underyling error changes
    func errorContextDidUpdate(_ context: ErrorContext)
}

/// An observable model that holds a single Error instance
public class ErrorContext {
    /// The error
    public var error: Error? {
        didSet {
            notifyObservers()
        }
    }

    private var observers = [ErrorContextObserving]()

    /**
     Initializes an instance

     - Returns: An `ErrorContext`
     */
    public init() {
        
    }

    /**
     Adds an observer to the context's list of observers. The observer will be
     notified of any changes to the underlying Error instance

     - Parameters:
     - observer: An object conforming to `ErrorContextObserving` to be added to the list of observers
     */
    public func addObserver(_ observer: ErrorContextObserving) {
        observers.append(observer)
    }

    /**
     Removes a given observer from the list of observers (if it had beed previously added)
     The observer will no longer be notified of changes to the underlying Error instance

     - Parameters:
     - observer: The `ErrorContextObserving` to be removed
     */
    public func removeObserver(_ observer: ErrorContextObserving) {
        _ = observers.firstIndex(where: { observer === $0 }).flatMap({ observers.remove(at: $0) })
    }

    private func notifyObservers() {
        for observer in observers {
            observer.errorContextDidUpdate(self)
        }
    }
}
