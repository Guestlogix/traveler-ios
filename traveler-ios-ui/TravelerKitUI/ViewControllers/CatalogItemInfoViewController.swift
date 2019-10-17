//
//  CatalogItemInfoViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

public protocol CatalogItemInfoViewControllerDelegate: class {
    func catalogItemInfoViewControllerDidChangePreferredContentSize(_ controller: CatalogItemInfoViewController)
}

open class CatalogItemInfoViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!

    weak var delegate: CatalogItemInfoViewControllerDelegate?
    var details: CatalogItemDetails? {
        didSet {
            segments = []

            if let info = details?.information, info.count > 0 {
                segments.append(.info)
            }

            if let _ = details?.contact {
                segments.append(.provider)
            } else if let locations = details?.locations, locations.count > 0 {
                segments.append(.provider)
            }
        }
    }

    enum Segment {
        case info
        case provider
    }

    private var selectedSegment: Segment?
    private var segments: [Segment] = []

    override open func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.removeAllSegments()

        segments.enumerated().forEach { (index, segment) in
            switch segment {
            case .info:
                segmentedControl.insertSegment(withTitle: "Info", at: index, animated: false)
            case .provider:
                segmentedControl.insertSegment(withTitle: "Provider", at: index, animated: false)
            }
        }

        if segments.count > 0 {
            segmentedControl.selectedSegmentIndex = 0
            selectedSegment = segments[0]
            performSegue(withIdentifier: selectedSegment!.segueIdentifier, sender: nil)
        } else {
            preferredContentSize = .zero
            delegate?.catalogItemInfoViewControllerDidChangePreferredContentSize(self)
        }
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue, segue.destination) {
        case (let segue as ContainerEmbedSegue, let vc as AttributesViewController):
            segue.containerView = containerView
            vc.attributes = details?.information
            vc.delegate = self
        case (let segue as ContainerEmbedSegue, let vc as ProviderInfoViewController):
            segue.containerView = containerView
            vc.contactInfo = details?.contact
            vc.locations = details?.locations
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        let segment = segments[sender.selectedSegmentIndex]
        performSegue(withIdentifier: segment.segueIdentifier, sender: nil)
    }
}

extension CatalogItemInfoViewController.Segment {
    var segueIdentifier: String {
        switch self {
        case .info:
            return "infoSegue"
        case .provider:
            return "providerSegue"
        }
    }
}

extension CatalogItemInfoViewController: AttributesViewControllerDelegate {
    public func attributesViewControllerDidChangePreferredContentSize(_ controller: AttributesViewController) {
        var size = controller.preferredContentSize
        size.height += containerView.frame.origin.y

        preferredContentSize = size
        delegate?.catalogItemInfoViewControllerDidChangePreferredContentSize(self)
    }
}

extension CatalogItemInfoViewController: ProviderInfoViewControllerDelegate {
    func providerInfoViewControllerDidChangePreferredContentSize(_ controller: ProviderInfoViewController) {
        var size = controller.preferredContentSize
        size.height += containerView.frame.origin.y

        preferredContentSize = size
        delegate?.catalogItemInfoViewControllerDidChangePreferredContentSize(self)
    }
}
