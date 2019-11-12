//
//  ParkingResultContext.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-08.
//  Copyright © 2019 Guestlogix Inc. All rights reserved.
//

import Foundation
import TravelerKit

public protocol ParkingResultContextObserving: class {
    func parkingResultContextDidUpdateResult(_ context: ParkingResultContext)
    func parkingResultContextDidChangeSelectedIndex(_ context: ParkingResultContext)
}

public class ParkingResultContext {
    private(set) var spots: [ParkingSpot]?

    var selectedIndex: Int? {
        didSet {
            notifyObserversWithSelectedIndexChange()
        }
    }

    var result: ParkingItemSearchResult? {
        didSet {
            spots = result?.items.values.map({ ParkingSpot(parkingItem: $0) })

            DispatchQueue.main.async {
                self.notifyObserversWithResultUpdate()
                self.selectedIndex = (self.spots?.count ?? 0) > 0 ? 0 : nil
            }
        }
    }

    private struct Observation {
        weak var observer: ParkingResultContextObserving?
    }
    private var observations = [ObjectIdentifier: Observation]()

    func addObserver(_ observer: ParkingResultContextObserving) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: ParkingResultContextObserving) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

    func notifyObserversWithSelectedIndexChange() {
        for (id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }

            observer.parkingResultContextDidChangeSelectedIndex(self)
        }
    }

    func notifyObserversWithResultUpdate() {
        for (id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }

            observer.parkingResultContextDidUpdateResult(self)
        }
    }
}
