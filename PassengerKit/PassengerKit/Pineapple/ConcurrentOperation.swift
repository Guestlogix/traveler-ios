//
//  ConcurrentOperation.swift
//  Cardinal
//
//  Created by Ata Namvari on 2017-05-07.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

// This class is a base Operation class for writing concurrent operations.
// Simply subclass it and override the `execute()` method.
// In there you can make your asynchronous call, just make sure you call
// `finish()` when work is done.

open class ConcurrentOperation: Operation {
    fileprivate var _finished = false
    fileprivate var _executing = false
    override fileprivate(set) open var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    override fileprivate(set) open var isExecuting: Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    override final public var isConcurrent: Bool {
        return true
    }

    override open var isAsynchronous: Bool {
        return true
    }


    override final public func start() {
        guard !isCancelled else {
            finish()
            return
        }

        isExecuting = true

        execute()
    }

    open func execute() {
        Log("\(type(of:self)) must override 'execute()'.", data: nil, level: .error)

        finish()
    }

    final public func finish() {
        if isExecuting {
            isExecuting = false
        }
        isFinished = true
    }
}
