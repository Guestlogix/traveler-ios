//
//  SearchOption.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-11.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

public struct SearchOption {
    public let title: String
    public let image: UIImage?
    
    public init(_ title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
}
