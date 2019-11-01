//
//  SimilarItemsResultViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-01.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

open class SimilarItemsResultViewController: CatalogResultViewController {
    private var selectedCatalogItem: CatalogItem?

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let navVC as UINavigationController):
            let vc = navVC.topViewController as? CatalogItemViewController
            vc?.catalogItem = selectedCatalogItem
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    override open func catalogView(_ catalogView: CatalogView, didSelectItemAt indexPath: IndexPath) {
        let catalogItem = catalog!.groups[indexPath.section].items[indexPath.row]
        self.selectedCatalogItem = catalogItem
        performSegue(withIdentifier: "itemSegue", sender: nil)
    }
}
