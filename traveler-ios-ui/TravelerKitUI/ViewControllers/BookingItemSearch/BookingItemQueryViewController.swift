//
//  BookingItemQueryViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-14.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class BookingItemQueryViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var keywordsField: UITextField!
    @IBOutlet weak var searchButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!

    public var query: BookingItemQuery?
    public var categories: [BookingItemCategory]?
    
    public override func viewDidLoad() {
        cityField.text = query?.city
        keywordsField.text = query?.text

        scrollView.keyboardDismissMode = .onDrag

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc
    func keyboardDidShow(_ note: Notification) {
        guard let keyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let activeField: UITextField? = [cityField, keywordsField].first { $0.isFirstResponder
        }

        let currentViewFrame = self.view.frame

        if let activeField = activeField {
            var offset = activeField.frame.origin.y - keyboardFrame.size.height

            if currentViewFrame.contains(activeField.frame.origin) && offset > 0 {

                //Check if active text field is the last one and if so, include button in offset.
                if searchButtonTopConstraint.secondItem as? UITextField == activeField {
                    offset = offset + searchButtonBottomConstraint.constant + searchButton.frame.size.height
                }

                let scrollPosition = CGPoint(x: 0, y: offset)
                scrollView.setContentOffset(scrollPosition, animated: true)
            }
        }
    }

    @objc
    func keyboardDidHide(_ note: Notification) {
        scrollView.contentInset  = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @objc
    func keyboardWillChangeFrame(_ note: Notification) {
        guard let keyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let viewControllerInView = view.convert(self.view.frame, from: nil)
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let bottomInset = viewControllerInView.intersection(keyboardFrameInView).height + 30

        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)

        self.view.layoutIfNeeded()
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc  as BookingItemQueryCategoryViewController):
            vc.delegate = self

        case ("bookingItemSearchSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? BookingItemSearchViewController
            var filters = BookingItemSearchFilters()
            filters.text = keywordsField.text!
            filters.city = cityField.text!
            filters.categories = categories
            query = query?.filterSearchWith(filters)
            vc?.searchQuery = query
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
    
    @IBAction func didPressCancel(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BookingItemQueryViewController: BookingItemQueryCategoryViewControllerDelegate {
    public func bookingItemQueryCategoryViewController(_ controller: BookingItemQueryCategoryViewController, didFinishWith categories: [BookingItemCategory]) {
        self.categories = categories
    }
}
