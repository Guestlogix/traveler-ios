//
//  FlightSearchViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import TravelerKit

protocol FlightLookupViewControllerDelegate: class {
    func flightLookupViewController(_ controller: FlightLookupViewController, didAdd flights: [Flight])
    func flightLookUpViewController(_ controller: FlightLookupViewController, canAdd flights: [Flight]) -> Bool
}

class FlightLookupViewController: UIViewController {
    weak var delegate: FlightLookupViewControllerDelegate?

    private(set) var flightQuery: FlightQuery?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let formVC as FlightLookupFormViewController):
            formVC.delegate = self
        case (_, let searchVC as FlightSearchViewController):
            searchVC.query = flightQuery
            searchVC.delegate = self
        case ("exitSegue"?, _):
            break
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension FlightLookupViewController: FlightLookupFormViewControllerDelegate {
    func flightLookupFormViewControllerDidSubmit(_ controller: FlightLookupFormViewController) {
        guard let flightNumber = controller.flightNumber, let flightDate = controller.flightDate else {
            Log("No flightNumber/flightDate", data: nil, level: .error)
            return
        }

        self.flightQuery = FlightQuery(number: flightNumber, date: flightDate)

        performSegue(withIdentifier: "searchSegue", sender: nil)
    }
}

extension FlightLookupViewController: FlightSearchViewControllerDelegate {
    func flightSearchViewControllerDidTryAgain(_ controller: FlightSearchViewController) {
        navigationController?.popToViewController(self, animated: true)
    }

    func flightSearchViewController(_ controller: FlightSearchViewController, didSelect flight: Flight) {
        delegate?.flightLookupViewController(self, didAdd: [flight])
    }
    
    func flightSearchViewController(_ controller: FlightSearchViewController, canAdd flight: Flight) -> Bool{
        return delegate?.flightLookUpViewController(self, canAdd: [flight]) ?? true
    }
}
