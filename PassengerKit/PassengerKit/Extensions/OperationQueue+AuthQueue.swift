//
//  OperationQueue+AuthQueue.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-18.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

extension OperationQueue {
    static let standardQueue: OperationQueue = {
        let queue = OperationQueue()
        return queue
    }()

    static let authQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
