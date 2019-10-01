//
//  GoogleTranslateAttribution.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-30.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/**
 A model containing the infromation required to display for attribution purposes on Google translate services
 */
public struct GoogleTranslateAttribution: Decodable {
    /// URL for a thumbnail
    public let image: URL?
    /// URL for link
    public let link: URL?

    enum CodingKeys: String, CodingKey {
        case image
        case link
    }

}
