//
//  ErrorContext.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public protocol ErrorContextObserving: class {
    func errorContextDidUpdate(_ context: ErrorContext)
}

public class ErrorContext {
    public var error: Error? {
        didSet {
            notifyObservers()
        }
    }

    private var observers = [ErrorContextObserving]()

    public init() {
        
    }

    public func addObserver(_ observer: ErrorContextObserving) {
        observers.append(observer)
    }

    public func removeObserver(_ observer: ErrorContextObserving) {
        _ = observers.firstIndex(where: { observer === $0 }).flatMap({ observers.remove(at: $0) })
    }

    private func notifyObservers() {
        for observer in observers {
            observer.errorContextDidUpdate(self)
        }
    }
}

extension ErrorContext {
    public func hasAnyOf(_ errors: [BookingError]) -> Bool {
        guard let error = error as? BookingError else {
            return false
        }

        return errors.contains(error)
    }
}
