//
//  ParkingFilterViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit
import CoreLocation

public protocol ParkingFilterViewControllerDelegate: class {
    func parkingFilterViewController(_ controller: ParkingFilterViewController, didUpdate query: ParkingItemQuery)
}

open class ParkingFilterViewController: UIViewController {
    var query: ParkingItemQuery?
    var parkingFilterContext: ParkingFilterContext?
    weak var delegate: ParkingFilterViewControllerDelegate?

    private let locationManager = CLLocationManager()
    private let nearMe = 0
    private let airport = 1

    override open func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_ , let navVC as ParkingQueryFormViewController):
            navVC.query = query
            navVC.parkingFilterContext = parkingFilterContext
            navVC.delegate = self
            navVC.locationManager = locationManager
        case ("noLocationSegue", let vc as ErrorViewController):
            vc.errorMessageString = "Location service is not available."
            break
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension ParkingFilterViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch (parkingFilterContext?.selectedFilter, status) {
        case (nearMe, .authorizedAlways),
             (nearMe, .authorizedWhenInUse),
             (airport, _):
            performSegue(withIdentifier: "filterFormSegue", sender: nil)
        case (nearMe, .denied),
             (nearMe, .restricted):
            performSegue(withIdentifier: "noLocationSegue", sender: nil)
        case (nearMe, .notDetermined):
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        performSegue(withIdentifier: "noLocationSegue", sender: nil)
    }
}

extension ParkingFilterViewController: ParkingQueryFormViewControllerDelegate {
    public func parkingQueryFormViewController(_ controller: ParkingQueryFormViewController, didUpdate query: ParkingItemQuery) {
        delegate?.parkingFilterViewController(self, didUpdate: query)
    }
}
