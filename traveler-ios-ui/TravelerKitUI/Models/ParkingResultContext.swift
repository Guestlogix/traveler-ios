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
            observers.forEach {
                $0.parkingResultContextDidChangeSelectedIndex(self)
            }
        }
    }

    private var observers = [ParkingResultContextObserving]()

    func addObserver(_ observer: ParkingResultContextObserving) {
        observers.append(observer)
    }

    func removeObserver(_ observer: ParkingResultContextObserving) {
        _ = observers.firstIndex(where: { observer === $0 }).flatMap({ observers.remove(at: $0) })
    }

    var result: ParkingItemSearchResult? {
        didSet {
            spots = result?.items.values.map({ ParkingSpot(parkingItem: $0) })

            DispatchQueue.main.async {
                self.observers.forEach {
                    $0.parkingResultContextDidUpdateResult(self)
                }

                self.selectedIndex = (self.spots?.count ?? 0) > 0 ? 0 : nil
            }
        }
    }
}
