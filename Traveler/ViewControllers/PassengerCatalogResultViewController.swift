//
//  PassengerCatalogResultViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import Foundation
import TravelerKitUI
import TravelerKit

class PassengerCatalogResultViewController: CatalogResultViewController {
    private(set) var selectedGroupIndex: Int?
    private(set) var selectedPurchasableIndex: Int?
    private(set) var selectedImage: UIImage?

    private var selectedCatalogItem: CatalogItem?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let navVC as UINavigationController):
            let vc = navVC.topViewController as? CatalogItemViewController
            vc?.catalogItem = selectedCatalogItem
            vc?.image = selectedImage
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    override func catalogView(_ catalogView: CatalogView, didSelectItemAt indexPath: IndexPath) {
        let catalogItem = catalog!.groups[indexPath.section].items[indexPath.row]
        self.selectedCatalogItem = catalogItem
        performSegue(withIdentifier: "itemSegue", sender: nil)
    }
}
