//
//  Price.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum ExchangeError: Error {
    case notAllowed
}

/// All prices come in this type that represents the value as well as the currency of the amount.
public struct Price: Decodable {
    private var value: Double
    /// The base currency of the amount.
    public private(set) var baseCurrency: Currency

    private var exchangeEnabled: Bool
    private var exchangeRates: ExchangeRates


    /// A convenience computed property for displaying a localized description of the amount in its base currency. e.g. "$431.23"
    public var localizedDescriptionInBaseCurrency: String? {
        return localizedDescription(in: baseCurrency)
    }

    /**
     A localized descriptions of the amount in a currency of choice. If the price does not allow currency exchange and the given
     currency is different than its base, nil is returned.

     - Parameters:
     - currency: The `Currency` to convert and display the localized value

     - Returns: A `String` if the value could be converted to the given `Currency`. nil otherwise
     */
    public func localizedDescription(in currency: Currency) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.currencyCode = currency.rawValue
        numberFormatter.numberStyle = .currency

        return numberFormatter.string(for: NSNumber(value: self.value))
    }

    /// The nominal value of the amount in its base currency
    public var valueInBaseCurrency: Double {
        return value
    }

    /**
     The nominal value of the amount in its base currency. If the price does not allow currency conversion and the given
     currency is different than its base, an `ExchangeError.notAllowed` is thrown.

     - Parameters:
     - currency: The `Currency` to convert the nominal value

     - Returns: The nominal value of the price in given `Currency`

     - Throws: An `ExchangeError.notAllowed` if the price doesn not allow currency conversion.
     */
    public func value(in currency: Currency) throws -> Double {
        guard currency != baseCurrency else {
            return value
        }

        guard exchangeEnabled else {
            throw ExchangeError.notAllowed
        }

        return value * exchangeRates.rate(for: currency)
    }
}

extension Price {
    private static func commonCurrency(_ lhs: Price, _ rhs: Price) -> Currency? {
        switch (lhs.baseCurrency, rhs.baseCurrency) {
        case (let lhsC, let rhsC) where lhsC == rhsC:
            return lhsC
        case (_, let rhsC) where lhs.exchangeEnabled:
            return rhsC
        case (let lhsC, _) where rhs.exchangeEnabled:
            return lhsC
        default:
            return nil
        }
    }

    public static func - (lhs: Price, rhs: Price) throws -> Price {
        guard let currency = commonCurrency(lhs, rhs) else {
            throw ExchangeError.notAllowed
        }

        return Price(value: (try! lhs.value(in: currency)) - (try! rhs.value(in: currency)),
                     baseCurrency: currency,
                     exchangeEnabled: lhs.exchangeEnabled && rhs.exchangeEnabled,
                     exchangeRates: lhs.exchangeEnabled ? lhs.exchangeRates : rhs.exchangeRates)
    }

    public static func += (lhs: inout Price, rhs: Price) throws {
        guard let currency = commonCurrency(lhs, rhs) else {
            throw ExchangeError.notAllowed
        }

        lhs.baseCurrency = currency
        lhs.value = (try! lhs.value(in: currency)) + (try! rhs.value(in: currency))
        lhs.exchangeEnabled = lhs.exchangeEnabled && rhs.exchangeEnabled
        lhs.exchangeRates = lhs.exchangeEnabled ? lhs.exchangeRates : rhs.exchangeRates
    }

    public static func + (lhs: Price, rhs: Price) throws -> Price {
        guard let currency = commonCurrency(lhs, rhs) else {
            throw ExchangeError.notAllowed
        }

        return Price(value: (try! lhs.value(in: currency)) + (try! rhs.value(in: currency)),
                     baseCurrency: currency,
                     exchangeEnabled: lhs.exchangeEnabled && rhs.exchangeEnabled,
                     exchangeRates: lhs.exchangeRates)
    }

    public static func -= (lhs: inout Price, rhs: Price) throws {
        guard let currency = commonCurrency(lhs, rhs) else {
            throw ExchangeError.notAllowed
        }

        lhs.baseCurrency = currency
        lhs.value = (try! lhs.value(in: currency)) - (try! rhs.value(in: currency))
        lhs.exchangeEnabled = lhs.exchangeEnabled && rhs.exchangeEnabled
        lhs.exchangeRates = lhs.exchangeEnabled ? lhs.exchangeRates : rhs.exchangeRates
    }
}

extension Price {
    public static func * (lhs: Double, rhs: Price) -> Price {
        return Price(value: rhs.value * lhs,
                     baseCurrency: rhs.baseCurrency,
                     exchangeEnabled: rhs.exchangeEnabled,
                     exchangeRates: rhs.exchangeRates)
    }

    public static func * (lhs: Price, rhs: Double) -> Price {
        return Price(value: lhs.value * rhs,
                     baseCurrency: lhs.baseCurrency,
                     exchangeEnabled: lhs.exchangeEnabled,
                     exchangeRates: lhs.exchangeRates)
    }

    public static func *= (lhs: inout Price, rhs: Double) {
        lhs.value *= rhs
    }
}

extension Price: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double

    public init(floatLiteral value: Double) {
        self.init(value: value, baseCurrency: .USD, exchangeEnabled: true, exchangeRates: .equalRates)
    }
}

public enum Currency: String, Decodable {
    case USD
    case CAD
    case AUD
    case EUR
    case GBP
}

struct ExchangeRates: Decodable {
    let usd: Double
    let cad: Double
    let aud: Double
    let eur: Double
    let gbp: Double

    func rate(for currency: Currency) -> Double {
        switch currency {
        case .USD:
            return usd
        case .CAD:
            return cad
        case .AUD:
            return aud
        case .EUR:
            return eur
        case .GBP:
            return gbp
        }
    }

    static var equalRates: ExchangeRates = {
        return ExchangeRates(usd: 1,
                             cad: 1,
                             aud: 1,
                             eur: 1,
                             gbp: 1)
    }()
}
