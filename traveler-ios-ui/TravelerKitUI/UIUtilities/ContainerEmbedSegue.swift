//
//  ContainerEmbedSegue.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

public class ContainerEmbedSegue : UIStoryboardSegue {
    public weak var containerView: UIView?

    public override func perform() {
        let containerView: UIView! = self.containerView ?? source.view

        source.children.forEach { (vc) in
            if vc.view.superview == containerView {
                vc.willMove(toParent: nil)
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            }
        }

        source.addChild(destination)
        let destView = destination.view!
        destView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        destView.frame = containerView.bounds
        containerView.addSubview(destView)
        destination.didMove(toParent: source)
    }
}
