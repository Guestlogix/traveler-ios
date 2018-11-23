//
//  CatalogResultViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import Foundation
import PassengerKit

class PassengerCatalogResultViewController: CatalogResultViewController {
    private(set) var selectedGroupIndex: Int?
    private(set) var selectedPurchasableIndex: Int?
    private(set) var selectedImage: UIImage?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case (_, let navVC as UINavigationController, let catalogItem as CatalogItem):
            let vc = navVC.topViewController as? CatalogItemViewController
            vc?.catalogItem = catalogItem
            vc?.image = selectedImage
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    override func catalogView(_ catalogView: CatalogView, didSelectItemAt indexPath: IndexPath) {
        let catalogItem = catalog!.groups[indexPath.section].items[indexPath.row]

        performSegue(withIdentifier: "itemSegue", sender: catalogItem)
    }
}
