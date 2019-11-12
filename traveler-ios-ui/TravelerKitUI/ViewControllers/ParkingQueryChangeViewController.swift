//
//  ParkingQueryChangeViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol ParkingQueryChangeViewControllerDelegate: class {
    func parkingQueryChangeViewController(_ controller: ParkingQueryChangeViewController, didUpdate query: ParkingItemQuery)
}

class ParkingQueryChangeViewController: UIViewController {
    @IBOutlet weak var locationSegmentedControl: UISegmentedControl!

    var query: ParkingItemQuery?
    weak var delegate: ParkingQueryChangeViewControllerDelegate?

    private let parkingFilterContext = ParkingFilterContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSegmentedControl.selectedSegmentIndex = query?.airportIATA == nil ? 0 : 1
        parkingFilterContext.selectedFilter = locationSegmentedControl.selectedSegmentIndex
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let navVC as ParkingFilterViewController):
            navVC.parkingFilterContext = parkingFilterContext
            navVC.query = query
            navVC.delegate = self
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }

    @IBAction func locationSegmentDidChange(_ sender: UISegmentedControl) {
        parkingFilterContext.selectedFilter = sender.selectedSegmentIndex
    }

}

extension ParkingQueryChangeViewController: ParkingFilterViewControllerDelegate {
    func parkingFilterViewController(_ controller: ParkingFilterViewController, didUpdate query: ParkingItemQuery) {
        delegate?.parkingQueryChangeViewController(self, didUpdate: query)
    }
}



