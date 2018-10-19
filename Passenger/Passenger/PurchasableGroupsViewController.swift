//
//  PurchasablesViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-03.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import PassengerKit

struct Purchasable {
    let title: String
    let subTitle: String
    let imageURL: URL?
}

struct PurchasableGroup {
    let isFeatured: Bool
    let title: String
    var purchasables: [Purchasable]
}



let purchasableGroupCellIdentifier = "purchasableGroupCellIdentifier"

class PurchasableGroupsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var groups: [PurchasableGroup]?

    private(set) var selectedGroupIndex: Int?
    private(set) var selectedPurchasableIndex: Int?

    override func awakeFromNib() {
        super.awakeFromNib()

        tableView.register(UINib(nibName: "CarouselViewCell", bundle: nil), forCellReuseIdentifier: purchasableGroupCellIdentifier)
    }
}

extension PurchasableGroupsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: purchasableGroupCellIdentifier, for: indexPath) as! CarouselViewCell
        let group = groups![indexPath.row]

        cell.dataSource = self
        cell.delegate = self
        cell.headerLabel.text = group.title
        cell.moreButton.setTitle("See more", for: .normal)
        cell.reload()
        cell.tag = indexPath.row

        return cell
    }
}

extension PurchasableGroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let group = groups![indexPath.row]

        if group.isFeatured {
            return featuredItemSize.height + (2 * CarouselItemViewCell.margin) + CarouselViewCell.headerHeight + CarouselItemViewCell.footerHeight
        } else {
            return PurchasableGroupsViewController.standardItemSize.height + (2 * CarouselItemViewCell.margin) + CarouselItemViewCell.footerHeight + CarouselViewCell.headerHeight
        }
    }
}

extension PurchasableGroupsViewController: CarouselViewCellDataSource {
    func numberOfItemsInCell(_ cell: CarouselViewCell) -> Int {
        return groups![cell.tag].purchasables.count
    }

    func carouselCell(_ cell: CarouselViewCell, configure itemCell: CarouselItemViewCell, at index: Int) {
        let purchasable = groups![cell.tag].purchasables[index]
        itemCell.titleLable.text = purchasable.title
        itemCell.subTitleLabel.text = purchasable.subTitle
        itemCell.imageView.image = nil

        if let url = purchasable.imageURL {
            AssetManager.shared.loadImage(with: url) { [weak itemCell] (image) in
                itemCell?.imageView.image = image
            }
        }
    }
}

extension PurchasableGroupsViewController: CarouselViewCellDelegate {
    func sizeForItemsInCell(_ cell: CarouselViewCell) -> CGSize {
        let group = groups![cell.tag]

        if group.isFeatured {
            return featuredItemSize
        } else {
            return PurchasableGroupsViewController.standardItemSize
        }
    }

    func carouselCellDidPressMoreButton(_ cell: CarouselViewCell) {
        let group = groups![cell.tag]

        // GOTO category VIEWCONTROLLER
    }

    func carouselCell(_ cell: CarouselViewCell, didSelectItemAt index: Int) {
        let purchasable = groups![cell.tag].purchasables[index]
        let purchasableVC = UINib(nibName: "PurchasableViewController", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PurchasableViewController

        self.selectedGroupIndex = cell.tag
        self.selectedPurchasableIndex = index

        purchasableVC.transitioningDelegate = self
        purchasableVC.modalPresentationStyle = .custom
        purchasableVC.modalPresentationCapturesStatusBarAppearance = true

        if let url = purchasable.imageURL {
            AssetManager.shared.loadImage(with: url) { [weak purchasableVC] (image) in
                purchasableVC?.imageView.image = image
            }
        }
        present(purchasableVC, animated: true)
    }
}

extension PurchasableGroupsViewController {
    static var itemRatio: CGFloat {
        return 16.0 / 9.0;
    }

    static var standardItemSize: CGSize {
        let value: CGFloat = 60
        return CGSize(width: (value * itemRatio), height: value)
    }

    var featuredItemSize: CGSize {
        let value = tableView.bounds.width - (2 * CarouselItemViewCell.margin)
        return CGSize(width: value,
                      height: value * PurchasableGroupsViewController.itemRatio)
    }
}

extension PurchasableGroupsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let groupIndex = selectedGroupIndex, let purchasableIndex = selectedPurchasableIndex, let vc = presented as? PurchasableViewController else {
            return nil
        }

        let cell = tableView.cellForRow(at: IndexPath(row: groupIndex, section: 0)) as! CarouselViewCell
        let itemCell = cell.collectionView.cellForItem(at: IndexPath(item: purchasableIndex, section: 0)) as! CarouselItemViewCell

        return Animator(fromView: itemCell.imageContainerView, toView: vc.imageContainerView)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let groupIndex = selectedGroupIndex, let purchasableIndex = selectedPurchasableIndex, let vc = dismissed as? PurchasableViewController else {
            return nil
        }

        let cell = tableView.cellForRow(at: IndexPath(row: groupIndex, section: 0)) as! CarouselViewCell
        let itemCell = cell.collectionView.cellForItem(at: IndexPath(item: purchasableIndex, section: 0)) as! CarouselItemViewCell

        return nil
    }
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    let fromView: UIView
    let toView: UIView

    init(fromView: UIView, toView: UIView) {
        self.fromView = fromView
        self.toView = toView
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let container = transitionContext.containerView
        let fromView = self.fromView
        let toView = self.toView

        toVC.view.setNeedsLayout()
        toVC.view.layoutIfNeeded()

        let snapshot = fromView.snapshotView(afterScreenUpdates: false)!
        fromView.isHidden = true
        toView.isHidden = true

        toVC.view.alpha = 0
        let finalFrame = transitionContext.finalFrame(for: toVC)
        var frame = finalFrame
        frame.origin.y += frame.size.height
        toVC.view.frame = frame
        container.addSubview(toVC.view)

        snapshot.frame = container.convert(fromView.bounds, from: fromView)
        container.addSubview(snapshot)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.alpha = 1
            toVC.view.frame = finalFrame
            snapshot.frame = container.convert(toView.frame, from: toView)
        }) { (finished) in
            fromView.isHidden = false
            toView.isHidden = false
            snapshot.removeFromSuperview()

            transitionContext.completeTransition(finished)
        }
    }
}
