//
//  QueryItem.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// An item in the `CatalogGroup` that contains a query
public struct QueryItem: CatalogItem, Decodable {
    /// Secondary title
    public let subTitle: String?
    /// Title
    public let title: String
    /// URL for a thumbnail
    public let imageURL: URL?
    /// A `SearchQuery` 
    public var query: SearchQuery
    /// Indicates if item is available
    /// It's initialized as `true` becuase a `QueryItem` is always available. 
    public let isAvailable = true

    enum CodingKeys: String, CodingKey {
        case subtitle = "subTitle"
        case title = "title"
        case imageURL = "thumbnail"
        case searchParams = "searchParams"
        case type = "type"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subTitle = try container.decode(String?.self, forKey: .subtitle)
        self.title = try container.decode(String.self, forKey: .title)
        self.imageURL = try container.decode(URL?.self, forKey: .imageURL)
        let type = try container.decode(QueryType.self, forKey: .type)

        switch type {
        case .booking:
            let queryParams = try container.decode(BookingItemSearchParameters.self, forKey: .searchParams)
            let bookingQuery = BookingItemQuery(with: queryParams)
            self.query = .booking(bookingQuery)
        case .parking:
            let queryParams = try container.decode(ParkingItemSearchParameters.self, forKey: .searchParams)
            let parkingQuery = ParkingItemQuery(with: queryParams)
            self.query = .parking(parkingQuery)
        }
    }
}
