//
//  CatalogViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-10-31.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

let identifier: String = "CarouselItemViewCell"

open class CatalogViewController: UIViewController, CatalogViewDataSouce, CatalogViewDelegate {
    final weak var catalogView: CatalogView!

    open override func viewDidLoad() {
        super.viewDidLoad()

        let catalogView = CatalogView()
        catalogView.translatesAutoresizingMaskIntoConstraints = false
        catalogView.delegate = self
        catalogView.dataSource = self

        view.addSubview(catalogView)

        view.addConstraints([
            catalogView.topAnchor.constraint(equalTo: view.topAnchor),
            catalogView.rightAnchor.constraint(equalTo: view.rightAnchor),
            catalogView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            catalogView.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])

        self.catalogView = catalogView
    }

    // MARK: CatalogViewDataSource

    open func numberOfGroups(in catalogView: CatalogView) -> Int {
        return 0
    }

    open func catalogView(_ catalogView: CatalogView, numberOfItemsIn group: Int) -> Int {
        return 0
    }

    open func catalogView(_ catalogView: CatalogView, configure: CarouselItemViewCell, at indexPath: IndexPath) {

    }

    open func catalogView(_ catalogView: CatalogView, titleForHeaderIn group: Int) -> String? {
        return nil
    }

    open func catalogView(_ catalogView: CatalogView, titleForAccessoryButtonIn group: Int) -> String? {
        return nil
    }
    
    open func catalogView(_ catalogView: CatalogView, identifierFor group: Int) -> String  {
        return identifier
    }

    // MARK: CatalogViewDelegate

    open func catalogView(_ catalogView: CatalogView, heightForHeaderIn group: Int) -> CGFloat {
        return CarouselViewCell.headerHeight
    }

    open func catalogView(_ catalogView: CatalogView, heightForItemFooterIn group: Int) -> CGFloat {
        return CarouselItemViewCell.footerHeight
    }

    open func catalogView(_ catalogView: CatalogView, sizeForItemsIn group: Int) -> CGSize {
        let value: CGFloat = 60
        return CGSize(width: (value * 16.0 / 9.0), height: value)
    }

    open func catalogView(_ catalogView: CatalogView, spacingBetweenItemsIn group: Int) -> CGFloat {
        return CarouselItemViewCell.margin * 2
    }

    open func catalogView(_ catalogView: CatalogView, didPressAccessoryButtonIn group: Int) {

    }

    open func catalogView(_ catalogView: CatalogView, didSelectItemAt indexPath: IndexPath) {

    }
}
