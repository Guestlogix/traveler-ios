//
//  EphemeralKey.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-11-11.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

public struct EphemeralKey: Decodable {
    public let jsonKey: Any

    enum CodingKeys: String, CodingKey {
        case key
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base64EncodedJSON = try container.decode(String.self, forKey: .key)

        guard let data = Data(base64Encoded: base64EncodedJSON) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.key, in: container, debugDescription: "JSONKey not Base64 encoded")
        }

        self.jsonKey = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
}
