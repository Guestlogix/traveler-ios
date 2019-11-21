//
//  ItineraryByDay.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-12-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

// TODO: Think of a way to make this more generic and if possible move into Core
public class ItineraryByDay {
    var daysAvailable = [Date]()
    var itemsByDay = [Date: [ItineraryItem]]()
    var types = [ItineraryItemType]()
    
    var dateRange: ClosedRange<Date>?
    
    convenience init(_ result: ItineraryResult, currentDateRange: ClosedRange<Date>?) {
        self.init()
        
        var types = [ItineraryItemType: Bool]()
        
        let items = result.items.sorted {
            $0.startDate < $1.startDate
        }
        
        if let currentDateRange = currentDateRange {
            dateRange = currentDateRange
        } else if let fromDate = items.first?.startDate, let toDate = items.last?.startDate {
            dateRange = fromDate...toDate
        } else {
            dateRange = Date().minTimeOfDay()...Date().maxTimeOfDay()
        }
        
        for item in items {
            let date = item.startDate.minTimeOfDay()
            
            if let dataItems = self.itemsByDay[date] {
                itemsByDay[date] = dataItems + [item]
            } else {
                itemsByDay[date] = [item]
                daysAvailable.append(date)
            }
            
            if types[item.type] == nil {
                types[item.type] = true
                self.types.append(item.type)
            }
        }
    }
    
    func filteredItinerary(by dateRange: ClosedRange<Date>?, types: [ItineraryItemType]) -> ItineraryByDay {
        let filteredItinerary = ItineraryByDay()
        filteredItinerary.dateRange = dateRange ?? self.dateRange
        filteredItinerary.types = types.isEmpty ? self.types : types
        
        for section in daysAvailable {
            if let items = itemsByDay[section] {
                filteredItinerary.itemsByDay[section] = items.filter {
                    $0.startDate >= filteredItinerary.dateRange!.lowerBound.minTimeOfDay() && $0.startDate <= filteredItinerary.dateRange!.upperBound.maxTimeOfDay() && filteredItinerary.types.contains($0.type)
                }
                
                if !filteredItinerary.itemsByDay[section]!.isEmpty {
                    filteredItinerary.daysAvailable.append(section)
                }
            }
        }
        
        return filteredItinerary
    }
}
