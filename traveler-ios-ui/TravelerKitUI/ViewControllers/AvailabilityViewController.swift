//
//  AvailabilityViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-08-14.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol AvailabilityViewControllerDelegate: class {
    func availabilityViewController(_ controller: AvailabilityViewController, didFinishWith bookingForm: BookingForm)
}

open class AvailabilityViewController: UIViewController {
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var monthYearLable: UILabel!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var calendarContainer: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    weak var delegate: AvailabilityViewControllerDelegate?

    var product: BookingItem?
    private var selectedAvailability: Availability?
    var availabilityError: Error?
    var availableOptions: [BookingOption]? {
        return selectedAvailability?.optionSet?.options
    }
    var hasOptions: Bool {
        return availableOptions?.count ?? 0 > 0
    }
    var selectedOption: BookingOption?
    var optionsViewController: BookingOptionsViewController?
    var numberOfMonths = 12

    private var passes: [Pass]?
    private var pageController: UIPageViewController?
    private var calendarViewControllers: [Date: AvailabilityCalendarViewController] = [:]
    private var selectedDate = Date() {
        didSet {
            monthYearLable.text = DateFormatter.monthYear.string(from: selectedDate)

            if selectedDate == minimumDate {
                previousMonthButton.isEnabled = false
            } else if selectedDate == maximumDate {
                nextMonthButton.isEnabled = false
            } else {
                previousMonthButton.isEnabled = true
                nextMonthButton.isEnabled = true
            }
        }
    }
    private var minimumDate: Date?
    private var maximumDate: Date?

    override open func viewDidLoad() {
        super.viewDidLoad()

        monthYearLable.text = DateFormatter.monthYear.string(from: selectedDate)
        priceLabel.text = product?.price.localizedDescriptionInBaseCurrency
        nextButton.isEnabled = false

        minimumDate = selectedDate
        previousMonthButton.isEnabled = false
        maximumDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: minimumDate!)
        setupPageController()
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookingOptionsViewController):
            vc.product = product
            vc.selectedAvailability = selectedAvailability
            vc.delegate = self
        case (_, let vc as BookingPassesViewController):
            vc.passes = passes
            vc.product = product
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didSelectPreviousMonth(_ sender: Any) {
        guard let volatileDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) else {
            Log("Unknown error getting the date of previous month.", data: nil, level: .error)
            return
        }

        selectedDate = volatileDate
        if let calendarVC = calendarViewControllers[selectedDate] {
            pageController?.setViewControllers([calendarVC], direction: .reverse, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "BookingItem", bundle: Bundle(for: AvailabilityViewController.self))
            let calendarVC = storyboard.instantiateViewController(withIdentifier: "calendarVC") as! AvailabilityCalendarViewController
            calendarVC.delegate = self
            calendarVC.product = product
            calendarVC.representingDate = selectedDate
            calendarViewControllers[selectedDate] = calendarVC
            pageController?.setViewControllers([calendarVC], direction: .reverse, animated: true, completion: nil)
        }
    }

    @IBAction func didSelectNextMonth(_ sender: Any) {
        guard let volatileDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) else {
            Log("Unknown error getting the date of next month.", data: nil, level: .error)
            return
        }

        selectedDate = volatileDate
        if let calendarVC = calendarViewControllers[selectedDate] {
            pageController?.setViewControllers([calendarVC], direction: .forward, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "BookingItem", bundle: Bundle(for: AvailabilityViewController.self))
            let calendarVC = storyboard.instantiateViewController(withIdentifier: "calendarVC") as! AvailabilityCalendarViewController
            calendarVC.delegate = self
            calendarVC.product = product
            calendarVC.representingDate = selectedDate
            calendarViewControllers[selectedDate] = calendarVC
            pageController?.setViewControllers([calendarVC], direction: .forward, animated: true, completion: nil)
        }
    }

    @IBAction func didProceed(_ sender: Any) {
        guard let product = product else {
            Log("No product", data: nil, level: .error)
            return
        }

        guard let availability = selectedAvailability else {
            // TODO: show an alert
            return
        }

        nextButton.isEnabled = false

        if hasOptions == true {
            performSegue(withIdentifier: "optionSegue", sender: nil)
            nextButton.isEnabled = true
        } else {
            Traveler.fetchPasses(product: product, availability: availability, option: nil, delegate: self)
        }
    }

    private func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self

        addChild(pageController!)
        pageController?.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        pageController?.view.frame = calendarContainer.bounds
        calendarContainer.addSubview(pageController!.view)
        pageController?.didMove(toParent: self)

        let storyboard = UIStoryboard(name: "BookingItem", bundle: Bundle(for: AvailabilityViewController.self))
        let initialVC = storyboard.instantiateViewController(withIdentifier: "calendarVC") as! AvailabilityCalendarViewController
        initialVC.delegate = self
        initialVC.representingDate = selectedDate
        initialVC.product = product
        calendarViewControllers[selectedDate] = initialVC
        pageController?.setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
    }
}

extension AvailabilityViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first as? AvailabilityCalendarViewController, let representingDate = currentViewController.representingDate else {
            Log("Unknow view controller or no representing date.", data: nil, level: .error)
            return
        }

        selectedDate = representingDate
    }
}

extension AvailabilityViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard selectedDate != minimumDate else {
            return nil
        }

        guard let volatileDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) else {
            Log("Unknown error getting the date of next month.", data: nil, level: .error)
            return nil
        }

        if let calendarVC = calendarViewControllers[volatileDate] {
            return calendarVC
        } else {
            let storyboard = UIStoryboard(name: "BookingItem", bundle: Bundle(for: AvailabilityViewController.self))
            let calendarVC = storyboard.instantiateViewController(withIdentifier: "calendarVC") as! AvailabilityCalendarViewController
            calendarVC.delegate = self
            calendarVC.product = product
            calendarVC.representingDate = volatileDate
            calendarViewControllers[volatileDate] = calendarVC
            return calendarVC
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard selectedDate != maximumDate else {
            return nil
        }

        guard let volatileDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) else {
            Log("Unknown error getting the date of next month.", data: nil, level: .error)
            return nil
        }

        if let calendarVC = calendarViewControllers[volatileDate] {
            return calendarVC
        } else {
            let storyboard = UIStoryboard(name: "BookingItem", bundle: Bundle(for: AvailabilityViewController.self))
            let calendarVC = storyboard.instantiateViewController(withIdentifier: "calendarVC") as! AvailabilityCalendarViewController
            calendarVC.delegate = self
            calendarVC.product = product
            calendarVC.representingDate = volatileDate
            calendarViewControllers[volatileDate] = calendarVC
            return calendarVC
        }
    }
}

extension AvailabilityViewController: PassFetchDelegate {
    public func passFetchDidSucceedWith(_ result: [Pass]) {
        if let _ = selectedOption {
            optionsViewController?.passFetchDidSucceedWith(result)
            return
        }

        self.passes = result

        performSegue(withIdentifier: "passSegue", sender: nil)

        nextButton.isEnabled = true
    }

    public func passFetchDidFailWith(_ error: Error) {
        if let _ = selectedOption {
            optionsViewController?.passFetchDidFailWith(error)
            return
        }

        nextButton.isEnabled = true

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true)
    }
}

extension AvailabilityViewController: BookingOptionsViewControllerDelegate {
    public func bookingOptionsViewController(_ controller: BookingOptionsViewController, didProceedWith option: BookingOption) {
        selectedOption = option
        optionsViewController = controller
        Traveler.fetchPasses(product: product!, availability: selectedAvailability!, option: option, delegate: self)
    }

    public func bookingOptionsViewController(_ controller: BookingOptionsViewController, didFinishWith bookingForm: BookingForm) {
        delegate?.availabilityViewController(self, didFinishWith: bookingForm)
    }
}

extension AvailabilityViewController: BookingPassesViewControllerDelegate {
    public func bookingPassesViewController(_ controller: BookingPassesViewController, didFinishWith bookingForm: BookingForm) {
        delegate?.availabilityViewController(self, didFinishWith: bookingForm)
    }
}

extension AvailabilityViewController: AvailabilityCalendarViewControllerDelegate {
    func availabilityCalendarViewController(_ controller: AvailabilityCalendarViewController, didSelect availability: Availability) {
        selectedAvailability = availability
        nextButton.isEnabled = true
    }
}
