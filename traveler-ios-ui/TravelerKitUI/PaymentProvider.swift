//
//  PaymentProvider.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

public protocol PaymentProvider {
    func paymentCollectorPackage() -> (UIViewController, PaymentHandler)
}
