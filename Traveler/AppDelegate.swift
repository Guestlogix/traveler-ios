//
//  AppDelegate.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-09-07.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import TravelerKit
import TravelerStripePaymentProvider
import TravelerKitUI
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // GoogleSignInSDK

        GIDSignIn.sharedInstance()?.clientID = Environment.gIDClientId
        GIDSignIn.sharedInstance()?.serverClientID = Environment.gIDServerClientID

        // TravelerSDK

        Traveler.initialize(apiKey: Environment.travelerKitKey, device: UIDevice.current)
        TravelerUI.initialize(paymentProvider: StripePaymentProvider())

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
