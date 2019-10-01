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
public struct ProviderTranslationAttribution: Decodable {
    /// URL for a thumbnail
    public let image: URL?

    enum CodingKeys: String, CodingKey {
        case image
    }

}
