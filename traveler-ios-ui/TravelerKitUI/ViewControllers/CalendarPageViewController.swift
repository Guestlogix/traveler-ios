//
//  CalendarPageViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-10-24.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

class CalendarPageViewController: UIPageViewController {
    private var calendarViewControllers: [Date: CalendarViewController]?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }

    // MARK: - UIPageViewControllerDataSource
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return 
    }
}

