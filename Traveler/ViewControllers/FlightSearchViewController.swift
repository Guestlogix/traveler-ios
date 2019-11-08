//
//  FlightSearchViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import TravelerKit
import TravelerKitUI

protocol FlightSearchViewControllerDelegate: class {
    func flightSearchViewControllerDidTryAgain(_ controller: FlightSearchViewController)
    func flightSearchViewController(_ controller: FlightSearchViewController, didSelect flight: Flight)
    func flightSearchViewController(_ controller: FlightSearchViewController, canAdd flight: Flight) -> Bool
}

class FlightSearchViewController: UIViewController {
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var flightDateLabel: UILabel!
    
    weak var delegate: FlightSearchViewControllerDelegate?
    var query: FlightQuery?

    private(set) var error: Error?
    private(set) var flights: [Flight]?

    override func viewDidLoad() {
        super.viewDidLoad()

        flightNumberLabel.text = query?.number
        flightDateLabel.text = query.flatMap({ DateFormatter.longFormatter.string(from: $0.date) })
        flightNumberLabel.textColor = UIColor.white
        flightDateLabel.textColor = UIColor.white

        reload()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue"?, let loadingVC as LoadingViewController):
            loadingVC.loadingTitleString = "Searching flights..."
        case ("exitSegue"?, _):
            break
        case ("emptySegue", let emptyVC as ErrorViewController):
            emptyVC.delegate = self
            emptyVC.errorTitleString = "No flights found"
            emptyVC.errorMessageString = "Please try again with a different flight number or departure date"
            emptyVC.retryButtonString = "Try Again"
        case ("errorSegue", let errorVC as ErrorViewController):
            errorVC.delegate = self
        case (_, let resultVC as FlightSearchResultViewController):
            resultVC.flights = flights
            resultVC.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    private func reload() {
        guard let query = query else {
            Log("No FlightQuery", data: nil, level: .error)
            return
        }

        performSegue(withIdentifier: "loadingSegue", sender: nil)

        Traveler.flightSearch(query: query, delegate: self)
    }
}

extension FlightSearchViewController: FlightSearchDelegate {
    func flightSearchDidSucceedWith(_ result: [Flight]) {
        self.flights = result

        if result.count == 0 {
            performSegue(withIdentifier: "emptySegue", sender: nil)
        } else {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }

    func flightSearchDidFailWith(_ error: Error) {
        self.error = error
        self.performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension FlightSearchViewController: EmptyViewControllerDelegate {
    func emptyViewControllerDidTryAgain(_ controller: EmptyViewController) {
        delegate?.flightSearchViewControllerDidTryAgain(self)
    }
}

extension FlightSearchViewController: ErrorViewControllerDelegate {
    func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        reload()
    }
}

extension FlightSearchViewController: FlightSearchResultViewControllerDelegate {
    func flightSearchResultViewController(_ controller: FlightSearchResultViewController, didSelect flight: Flight) {
        delegate?.flightSearchViewController(self, didSelect: flight)
    }
    
    func flightSearchResultViewController(_ controller: FlightSearchResultViewController, canAdd flight: Flight) -> Bool {
        return delegate?.flightSearchViewController(self, canAdd: flight) ?? true
    }
}
