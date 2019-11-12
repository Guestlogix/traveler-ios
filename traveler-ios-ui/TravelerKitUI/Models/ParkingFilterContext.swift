//
//  ParkingFilterContext.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

public protocol ParkingFilterContextObserving: class {
    func parkingFilterContextDidChangeSelectedFilter(_ context: ParkingFilterContext)
}

public class ParkingFilterContext {
    private(set) var filter: Int?

    private weak var delegate: ParkingFilterContextObserving?

    var selectedFilter: Int? {
        didSet {
            observers.forEach { $0.parkingFilterContextDidChangeSelectedFilter(self)}
        }
    }

    private var observers = [ParkingFilterContextObserving]()

    func addObserver(_ observer: ParkingFilterContextObserving) {
        observers.append(observer)
    }

    func removeObserver(_ observer: ParkingFilterContextObserving) {
        _ = observers.firstIndex(where: { observer === $0 }).flatMap({ observers.remove(at: $0) })
    }
}
