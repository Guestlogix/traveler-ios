//
//  OrderFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-05-06.
//  Copyright © 2019 Guestlogix Inc. All rights reserved.
//

import Foundation

public protocol OrderFetchDelegate: class {
    func orderFetchDidSucceedWith(_ result: OrderResult, identifier: AnyHashable?)
    func orderFetchDidFailWith(_ error: Error, identifier: AnyHashable?)
    func previousResult() -> OrderResult?
    func orderFetchDidReceive(_ result: OrderResult, identifier: AnyHashable?)
}

public extension OrderFetchDelegate {
    func previousResult() -> OrderResult? {
        return nil
    }

    func orderFetchDidReceive(_ result: OrderResult, identifier: AnyHashable?) {
        // Default no-op
    }
}
