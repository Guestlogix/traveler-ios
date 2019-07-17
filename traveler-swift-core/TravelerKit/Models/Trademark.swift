//
//  Trademark.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-07-17.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Holds trademark information about a `Supplier`
public struct Trademark: Decodable {
    /// The `Trademark`s logo or icon
    public let iconURL: URL
    /// The `Trademark`s copyright
    public let copyRight: String

    enum CodingKeys: String, CodingKey {
        case iconURL = "iconURL"
        case copyRight = "copyright"
    }

    init(iconURL: URL, copyRight: String) {
        self.iconURL = iconURL
        self.copyRight = copyRight
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let iconURLString = try container.decode(String.self, forKey: .iconURL)
        guard let iconURL = URL(string: iconURLString) else {
            throw DecodingError.dataCorruptedError(forKey: .iconURL, in: container, debugDescription: "Invalid URL for icon")
        }
        self.iconURL = iconURL

        self.copyRight = try container.decode(String.self, forKey: .copyRight)
    }
}
