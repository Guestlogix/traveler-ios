//
//  LossyDecodableArray.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-12-18.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/**
 https://kenb.us/lossy-decodable-for-arrays

 This model is used to futureproof against unhandled types that may arise from new features.
*/
struct LossyDecodableArray<T: Decodable>: Decodable {
    private struct FailableDecodable<T: Decodable>: Decodable {
        var t: T?
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            do {
                t = try container.decode(T.self)
            } catch {
                t = nil
                Log("FailableDecodable did fail to decode \(T.self)", data: error, level: .warning)
            }
        }
    }
    
    let payload: [T]

    init(from decoder: Decoder) throws {
        var payload = [T?]()
        var container = try decoder.unkeyedContainer()
        
        while !container.isAtEnd {
            let t = try container.decode(FailableDecodable<T>.self).t
            payload.append(t)
        }
        
        self.payload = payload.compactMap { $0 }
    }
}
