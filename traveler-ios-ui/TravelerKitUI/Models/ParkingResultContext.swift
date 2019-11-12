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

public class ParkingResultContext: ObservingContext {
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

    func notifyObserversWithSelectedIndexChange() {
        for (id, observation) in observations {
            guard let observer = observation.observer, let resultObserver = observer as? ParkingResultContextObserving else {
                observations.removeValue(forKey: id)
                continue
            }

            resultObserver.parkingResultContextDidChangeSelectedIndex(self)
        }
    }

    func notifyObserversWithResultUpdate() {
        for (id, observation) in observations {
            guard let observer = observation.observer, let resultObserver = observer as? ParkingResultContextObserving else {
                observations.removeValue(forKey: id)
                continue
            }

            resultObserver.parkingResultContextDidUpdateResult(self)
        }
    }
}
