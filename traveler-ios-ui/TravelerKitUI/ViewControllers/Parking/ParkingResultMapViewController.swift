//
//  ParkingResultMapViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-08.
//  Copyright © 2019 Guestlogix Inc. All rights reserved.
//

import Foundation
import TravelerKit
import MapKit

let parkingAnnotationIdentifier = "parkingAnnotationIdentifier"

protocol ParkingResultMapViewControllerDelegate: class {
    func parkingResultMapViewController(_ controller: ParkingResultMapViewController, didChange boundingBox: BoundingBox)
}

open class ParkingResultMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    var context: ParkingResultContext?
    weak var delegate: ParkingResultMapViewControllerDelegate?

    private var isSelecting = false
    private var queryUpdated = false

    override open func viewDidLoad() {
        super.viewDidLoad()

        mapView.register(LabeledAnnotationView.self, forAnnotationViewWithReuseIdentifier: parkingAnnotationIdentifier)

        context?.addObserver(self)
    }

    deinit {
        context?.removeObserver(self)
    }

    public func selectAnnotationWith(_ index: Int) {
        let selectedAnnotation = context!.spots![index]
        mapView.selectAnnotation(selectedAnnotation, animated: true)
        let visibleMapRect = mapView.visibleMapRect
        let visibleAnnotations = mapView.annotations(in: visibleMapRect)
        if visibleAnnotations.contains(selectedAnnotation) == false {         
            mapView.showAnnotations(context!.spots!, animated: true)
        }

        for annotationIndex in 0..<context!.spots!.count {
            if let annotationView = mapView.view(for: context!.spots![annotationIndex]) as? LabeledAnnotationView {
                annotationView.isChosen = annotationIndex == context?.selectedIndex ? true : false
            }
        }
    }
}

extension ParkingResultMapViewController: ParkingResultContextObserving {
    public func parkingResultContextDidChangeSelectedIndex(_ context: ParkingResultContext) {
        guard let index = context.selectedIndex else {
            return
        }

        isSelecting = true

        selectAnnotationWith(index)
        isSelecting = false
    }

    public func parkingResultContextDidUpdateResult(_ context: ParkingResultContext) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(context.spots ?? [])

        queryUpdated = true

        if let boundingBox = context.result?.query.boundingBox {
            mapView.setVisibleMapRect(MKMapRect(boundingBox: boundingBox), animated: false)
        } else {
            mapView.showAnnotations(context.spots ?? [], animated: false)
        }
    }
}

extension ParkingResultMapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !isSelecting, view.tag > -1, view.tag < (context?.spots?.count ?? -1) else {
            return
        }

        context?.selectedIndex = view.tag
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let parkingSpot = annotation as? ParkingSpot else {
            Log("MapAnnotation not a ParkingSpot", data: nil, level: .error)
            return nil
        }

        let view = mapView.dequeueReusableAnnotationView(withIdentifier: parkingAnnotationIdentifier, for: annotation) as! LabeledAnnotationView

        view.annotation = annotation
        view.prepareForDisplay()
        view.tag = context?.spots?.firstIndex(of: parkingSpot) ?? -1
        view.isChosen = view.tag == context?.selectedIndex ? true : false

        return view
    }

    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        guard !queryUpdated else {
            queryUpdated = false
            return
        }

        let rect = mapView.visibleMapRect
        let topLeftPoint = MKMapPoint(x: rect.minX, y: rect.maxY)
        let bottomRightPoint = MKMapPoint(x: rect.maxX, y: rect.minY)
        let topLeftCoordinate = Coordinate(latitude: topLeftPoint.coordinate.latitude, longitude: topLeftPoint.coordinate.longitude)
        let bottomRightCoodrinate = Coordinate(latitude: bottomRightPoint.coordinate.latitude, longitude: bottomRightPoint.coordinate.longitude)
        let boundingBox = BoundingBox(topLeftCoordinate: topLeftCoordinate, bottomRightCoordinate: bottomRightCoodrinate)

        guard context?.result?.query.boundingBox != boundingBox else {
            return
        }

        delegate?.parkingResultMapViewController(self, didChange: boundingBox)
    }
}
