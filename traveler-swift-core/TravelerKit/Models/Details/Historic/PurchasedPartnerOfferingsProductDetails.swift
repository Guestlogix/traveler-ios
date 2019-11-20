//
//  PurchasedPartnerOfferingsProductDetails.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-12-11.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

// TODO: Make decodable once backend changes to support single model aggregation and remove conformance to `PurchasedProduct`
/// The historic information of a `PartnerOfferingItem` combined with `PurchasedPartnerOfferingProduct`
public struct PurchasedPartnerOfferingsProductDetails: CatalogItemDetails, PurchasedProduct {
    /// Vendor's contact information
    public let contact: ContactInfo?
    /// A description
    public let description: String?
    /// Disclaimer
    public let disclaimer: String?
    /// An array of URLs of images
    public let imageUrls: [URL]
    /// Attributes
    public let information: [Attribute]?
    /// Price
    public let price: Price
    /// Product supplier
    public let supplier: Supplier
    /// Terms and conditions
    public let termsAndConditions: String?
    /// Title
    public let title: String

    //MARK:- `PurchasedPartnerOfferingProduct`
    /// Price of product
    public let finalPrice: Price
    /// Date in which the product takes place
    public let eventDate: Date
    /// Identifier
    public let id: String
    /// Order identifier
    public let orderId: String
    /// Order reference number
    public let orderReferenceNumber: String?
    /// Attributes
    public let purchaseInformation: [Attribute]
    /// Type
    public let purchaseType: PurchaseType
    
    public init(details: ParkingItemDetails, product: PurchasedParkingProduct) {
        self.contact = details.contact
        self.description = details.description
        self.disclaimer = details.disclaimer
        self.eventDate = product.eventDate
        self.finalPrice = product.finalPrice
        self.id = product.id
        self.imageUrls = details.imageUrls
        self.information = details.information
        self.orderId = product.orderId
        self.orderReferenceNumber = product.orderReferenceNumber
        self.price = details.price
        self.purchaseType = product.purchaseType
        self.purchaseInformation = product.information
        self.supplier = details.supplier
        self.termsAndConditions = details.termsAndConditions
        self.title = details.title
    }
}

