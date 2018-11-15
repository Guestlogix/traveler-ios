//
//  CatalogItemDetails.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct CatalogItemDetails: Decodable {
    let id: String

    public let title: String
    public private(set) var description: String
    public lazy var attributedDescription: NSMutableAttributedString? = {
        let attr = try? NSMutableAttributedString(data: description.data(using: .utf8)!,
                                                  options: [.documentType : NSAttributedString.DocumentType.html],
                                                  documentAttributes: nil)

        return attr
    }()

    public let imageUrls: [URL]
    public let information: [Attribute]?
    public let contact: ContactInfo?
    public let locations: [Location]
    public let priceStartingAt: Double
    public let purchaseStrategy: PurchaseStrategy

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrls
        case contact
        case locations
        case priceStartingAt
        case purchaseStrategy
        case information
    }
}
