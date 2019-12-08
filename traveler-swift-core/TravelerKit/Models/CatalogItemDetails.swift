//
//  CatalogItemDetails.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Detail information of Catalog Items 
public protocol CatalogItemDetails {
    /// Title
    var title: String { get }
    /// Description
    var description: String? { get }
    /// An array of URLs of images
    var imageUrls: [URL] { get }
    /// Attributes
    var information: [Attribute]? { get }
    /// Vendor's contact information
    var contact: ContactInfo? { get }
    /// Product supplier
    var supplier: Supplier { get }
    /// Disclaimer
    var disclaimer: String? { get }
    /// Terms and conditions
    var termsAndConditions: String? { get }
}

struct AnyItemDetails: Decodable {

    let payload: CatalogItemDetails

    enum CodingKeys: String, CodingKey {
        case type = "purchaseStrategy"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ProductType.self, forKey: .type)

        var itemDetail: CatalogItemDetails
        switch type {
        case .booking:
            itemDetail = try BookingItemDetails(from: decoder)
        case .parking:
            itemDetail = try ParkingItemDetails(from: decoder)
        case .partnerOffering:
            itemDetail = try PartnerOfferingItemDetail(from: decoder)
        }

        payload = itemDetail
    }
}
