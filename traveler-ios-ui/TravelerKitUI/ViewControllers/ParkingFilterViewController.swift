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

protocol ParkingFilterViewControllerDelegate {
    func parkingFilterViewController(_ controller: ParkingFilterViewController, didUpdate query: ParkingItemQuery)
}

class ParkingFilterViewController: UIViewController {

    var query: ParkingItemQuery?
    var parkingFilterContext: ParkingFilterContext?
    var delegate: ParkingFilterViewControllerDelegate?

    private let locationManager = CLLocationManager()
    private let nearMe = 0
    private let airport = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self

        switch (parkingFilterContext?.selectedFilter, CLLocationManager.locationServicesEnabled(), CLLocationManager.authorizationStatus()) {

        case (airport, _ , _),
             (nearMe, true, .authorizedWhenInUse),
             (nearMe, true, .authorizedAlways):
            performSegue(withIdentifier: "filterFormSegue", sender: nil)
        case (nearMe, false, _ ), (nearMe, _, .denied), (nearMe, _, .restricted):
            performSegue(withIdentifier: "noLocationSegue", sender: nil)
        case (nearMe, true, .notDetermined):
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_ , let navVC as ParkingQueryFormViewController):
            navVC.query = query
            navVC.parkingFilterContext = parkingFilterContext
            navVC.delegate = self
            navVC.locationManager = locationManager
        case ("noLocationSegue", _):
            break
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension ParkingFilterViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

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

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        performSegue(withIdentifier: "noLocationSegue", sender: nil)
    }
}

extension ParkingFilterViewController: ParkingQueryFormViewControllerDelegate {
    func parkingQueryFormViewController(_ controller: ParkingQueryFormViewController, didUpdate query: ParkingItemQuery) {
        delegate?.parkingFilterViewController(self, didUpdate: query)
    }
}
