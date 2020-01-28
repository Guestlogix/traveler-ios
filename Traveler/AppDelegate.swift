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

        #if TRAVELER
        Traveler.initialize(apiKey: Environment.travelerKitKey, device: UIDevice.current, sandboxMode: true)
        #endif

        #if GCREW
        Traveler.initialize(apiKey: Environment.travelerKitKey, device: UIDevice.current)
        #endif

        TravelerUI.initialize(paymentHandler: PaymentCollectionViewController.self,
                              paymentAuthenticator: StripePaymentAuthenticator(),
                              paymentManager: StripePaymentProvider.self)

        // Temp Styles

        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(red: 45.0 / 255.0, green: 91.0 / 255.0, blue: 166.0 / 255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]

        UISearchBar.appearance().tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        // End Temp Styles
        //
        return true
    }
}
