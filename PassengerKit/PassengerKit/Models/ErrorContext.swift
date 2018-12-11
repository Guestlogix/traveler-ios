//
//  ErrorContext.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

protocol ErrorContextObserving: class {
    func errorContextDidUpdate(_ context: ErrorContext)
}

class ErrorContext {
    var error: Error? {
        didSet {
            notifyObservers()
        }
    }

    private var observers = [ErrorContextObserving]()

    func addObserver(_ observer: ErrorContextObserving) {
        observers.append(observer)
    }

    func removeObserver(_ observer: ErrorContextObserving) {
        _ = observers.firstIndex(where: { observer === $0 }).flatMap({ observers.remove(at: $0) })
    }

    private func notifyObservers() {
        for observer in observers {
            observer.errorContextDidUpdate(self)
        }
    }
}

extension ErrorContext {
    func hasAnyOf(_ errors: [BookingError]) -> Bool {
        guard let error = error as? BookingError else {
            return false
        }

        return errors.contains(error)
    }
}
