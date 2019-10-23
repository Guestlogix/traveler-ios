//
//  JSONValue.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-23.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

/**
 Helper enum to mock JSON data. More information here: https://medium.com/grand-parade/creating-type-safe-json-in-swift-74a612991893
 */

import Foundation

enum MockJSON {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case object([String: MockJSON])
    case array([MockJSON])
    case null
}

extension MockJSON: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .null: try container.encodeNil()
        case .string(let string): try container.encode(string)
        case .int(let int): try container.encode(int)
        case .double(let double): try container.encode(double)
        case .bool(let bool): try container.encode(bool)
        case .object(let object): try container.encode(object)
        case .array(let array): try container.encode(array)
        }
    }
}

extension MockJSON {
    func jsonString(file: StaticString =  #file, line: UInt = #line) -> String? {
        do {
            switch self {
            case .null: return nil
            case .string(let string): return string
            case .int(let int): return String(int)
            case .double(let double): return String(double)
            case .bool(let bool): return String(bool)
            case .object, .array: guard let value = try String(data: JSONEncoder().encode(self), encoding: .utf8) else {
                fatalError("Error in test data! String could not be parsed from data", file: file, line: line)
            }
            return value
            }

        } catch {
            fatalError("Error in test data! \(error.localizedDescription)", file: file, line: line)
        }
    }
}

extension MockJSON: ExpressibleByStringLiteral {
    public init (stringLiteral value: String) {
        self = .string(value)
    }
}

extension MockJSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension MockJSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension MockJSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension MockJSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: MockJSON...) {
        self = .array(elements)
    }
}

extension MockJSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, MockJSON)...) {
        self = .object([String: MockJSON](uniqueKeysWithValues: elements))
    }
}

extension MockJSON: ExpressibleByNilLiteral {
    init(nilLiteral: ()) {
        self = .null
    }
}
