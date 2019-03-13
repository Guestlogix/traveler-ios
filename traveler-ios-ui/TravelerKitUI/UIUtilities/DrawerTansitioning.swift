//
//  DrawerTansitioning.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-10.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol DrawerTransitioning {
    func drawerViewForTransition(context: UIViewControllerContextTransitioning) -> UIView
}
