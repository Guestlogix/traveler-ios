//
//  CatalogResultViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import Foundation
import PassengerKit
//import Stripe

class PassengerCatalogResultViewController: CatalogResultViewController {
    private(set) var selectedGroupIndex: Int?
    private(set) var selectedPurchasableIndex: Int?
    private(set) var selectedImage: UIImage?

    private var order: Order?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case (_, let navVC as UINavigationController, let catalogItem as CatalogItem):
            let vc = navVC.topViewController as? CatalogItemViewController
            vc?.catalogItem = catalogItem
            vc?.image = selectedImage
            vc?.delegate = self
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

extension PassengerCatalogResultViewController: CatalogItemViewControllerDelegate {
    func catalogItemViewController(_ controller: CatalogItemViewController, didCreate order: Order) {
        //let addCardViewController = STPAddCardViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default())
        //addCardViewController.delegate = controller

        //controller.present(addCardViewController, animated: true)
    }
}

//extension CatalogItemViewController: STPAddCardViewControllerDelegate {
//    public func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//        addCardViewController.dismiss(animated: true, completion: nil)
//    }
//
//    public func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
//        let payment = StripePayment(stripeToken: token, completion: completion)
//        performSegue(withIdentifier: "paymentSegue", sender: payment)
//    }
//}
