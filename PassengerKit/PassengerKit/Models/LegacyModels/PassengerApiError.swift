//
//  PassengerApiError.swift
//  Guestlogix
//
//  Created by TribalScale on 7/16/18.
//  Copyright © 2018 TribalScale. All rights reserved.
//

struct PassengerApiError: Decodable {

    var code: Int

    var message: String

    var stack: String?

    private enum CodingKeys: String, CodingKey {

        case code = "errorCode"

        case message = "errorMessage"

        case stack

    }

}
