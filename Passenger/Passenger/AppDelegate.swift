//
//  AppDelegate.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-09-07.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import PassengerKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        PassengerKit.initialize(apiKey: "XJ7B8mFnPj6O8MT4KuwzF9sg4OtxaR6w7EeytIIT")

//        PassengerKit.identify(user.email) { glxUser in
//
//        }
//
//        PassngerKit.fetchOrders(glxUser) { orders in
//
//        }

        // Temp Styles

        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(red: 45.0 / 255.0, green: 91.0 / 255.0, blue: 166.0 / 255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]

        // End Temp Styles

        return true
    }
}

