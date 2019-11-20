//
//  PurchasedParkingProductDetails.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-12-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

// TODO: Make decodable once backend changes to support single model aggregation and remove conformance to `PurchasedProduct`
/// The historic information of a `ParkingItem` combined with `PurchasedParkingProduct`
public struct PurchasedParkingProductDetails: CatalogItemDetails, PurchasedProduct {
    /// Vendor's contact information
    public let contact: ContactInfo?
    /// Dates
    public var dateRange: Range<Date>
    /// Description
    public let description: String?
    /// Disclaimer
    public let disclaimer: String?
    /// An array of URLs of images
    public let imageUrls: [URL]
    /// Attributes
    public let information: [Attribute]?
    /// Indicating if it's wishlisted
    public let isWishlisted: Bool?
    /// An array of locations
    public let locations: [Location]
    /// Price
    public let price: Price
    /// Amount to be paid online
    public let priceToPayOnline: Price
    /// Amount to be paid on site
    public let priceToPayOnsite: Price
    /// Secondary title
    public let subTitle: String
    /// Product supplier
    public let supplier: Supplier
    /// Terms and conditions
    public let termsAndConditions: String?
    /// URL for a thumbnail
    public let thumbnailURL: URL?
    /// Title
    public let title: String
    /// Translate attribution
    public let translateAttribution: ProviderTranslationAttribution?

    //MARK:- `PurchasedParkingProduct`
    /// Price of product
    public let finalPrice: Price
    /// Date in which the product takes place
    public let eventDate: Date
    /// Identifier
    public let id: String
    /// Order detail information
    public let orderDetail: String?
    /// Order identifier
    public let orderId: String
    /// Order reference number
    public let orderReferenceNumber: String?
    /// Array of different `Pass`es purchased
    public let passes: [Pass]
    /// Primary contact information
    public let primaryContact: String?
    /// Attributes
    public let purchaseInformation: [Attribute]
    /// Type
    public let purchaseType: PurchaseType
    
    public init(details: ParkingItemDetails, product: PurchasedParkingProduct) {
        self.contact = details.contact
        self.dateRange = details.dateRange
        self.description = details.description
        self.disclaimer = details.disclaimer
        self.eventDate = product.eventDate
        self.finalPrice = product.finalPrice
        self.id = product.id
        self.imageUrls = details.imageUrls
        self.information = details.information
        self.isWishlisted = details.isWishlisted
        self.locations = details.locations
        self.orderDetail = product.orderDetail
        self.orderId = product.orderId
        self.orderReferenceNumber = product.orderReferenceNumber
        self.passes = product.passes
        self.price = details.price
        self.priceToPayOnline = details.priceToPayOnline
        self.priceToPayOnsite = details.priceToPayOnsite
        self.primaryContact = product.primaryContact
        self.purchaseType = product.purchaseType
        self.purchaseInformation = product.information
        self.subTitle = details.subTitle
        self.supplier = details.supplier
        self.termsAndConditions = details.termsAndConditions
        self.thumbnailURL = details.thumbnailURL
        self.title = details.title
        self.translateAttribution = details.translateAttribution
    }
}
