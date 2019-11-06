//
//  CancellationReason.swift
//  TravelerKit
//
//  Created by Ben Ruan on 2019-10-02.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// This represents the reason why user wants to cancel the corresponding `Order`
public struct CancellationReason: Decodable {
    /// Identifier of the cancellation reason
    let id: String
    /// Text representation of the cancellation reason
    public let description: String
    /// Boolean value indicating if text explanation needs to be provided by user
    public let explanationRequired: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case description = "value"
        case explanationRequired = "explanationRequired"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.description = try container.decode(String.self, forKey: .description)
        self.explanationRequired = try container.decode(Bool.self, forKey: .explanationRequired)
    }
}
