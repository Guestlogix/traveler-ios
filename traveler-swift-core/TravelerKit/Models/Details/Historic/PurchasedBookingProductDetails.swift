//
//  PurchasedBookingProductDetails.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-12-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

// TODO: Make decodable once backend changes to support single model aggregation and remove conformance to `PurchasedProduct`
/// The historic information of a `BookingItem` combined with `PurchasedBookingProduct`
public struct PurchasedBookingProductDetails: CatalogItemDetails, PurchasedProduct {
    /// Categories
    public let categories: [BookingItemCategory]
    /// Vendor's contact information
    public let contact: ContactInfo?
    /// Description
    public let description: String?
    /// Disclaimer
    public let disclaimer: String?
    /// An array of URLs of images
    public let imageUrls: [URL]
    /// Attributes
    public let information: [Attribute]?
    /// Indicating if its wishlisted
    public let isWishlisted: Bool?
    /// An array of locations
    public let locations: [Location]
    /// Price
    public let price: Price
    /// Product supplier
    public let supplier: Supplier
    /// Terms and conditions
    public let termsAndConditions: String?
    /// Title
    public let title: String
    /// Google translate attribution
    public let translateAttribution: ProviderTranslationAttribution
    
    //MARK:- `PurchasedBookingProduct`
    /// Date in which the product takes place
    public let eventDate: Date
    /// Price of product
    public let finalPrice: Price
    /// Identifier
    public let id: String
    /// Order identifier
    public let orderId: String
    /// Order reference number
    public let orderReferenceNumber: String?
    /// Array of different `Pass`es purchased
    public let passes: [Pass]
    /// Attributes
    public let purchaseInformation: [Attribute]?
    /// Type
    public let purchaseType: PurchaseType
    
    public init(details: BookingItemDetails, product: PurchasedBookingProduct) {
        self.categories = details.categories
        self.contact = details.contact
        self.description = details.description
        self.disclaimer = details.disclaimer
        self.eventDate = product.eventDate
        self.finalPrice = product.finalPrice
        self.id = product.id
        self.imageUrls = details.imageUrls
        self.information = details.information
        self.isWishlisted = details.isWishlisted
        self.locations = details.locations
        self.orderId = product.orderId
        self.orderReferenceNumber = product.orderReferenceNumber
        self.passes = product.passes
        self.price = details.price
        self.purchaseType = product.purchaseType
        self.purchaseInformation = product.information
        self.supplier = details.supplier
        self.termsAndConditions = details.termsAndConditions
        self.title = details.title
        self.translateAttribution = details.translateAttribution
    }
}
