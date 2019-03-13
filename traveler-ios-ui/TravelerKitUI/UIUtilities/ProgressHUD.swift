//
//  ProgressHUD.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

public class ProgressHUD {
    private static let shared = ProgressHUD()

    private let window: UIWindow
    private let hudViewController = HUDViewController()

    private init() {
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        self.window.isHidden = true
        self.window.windowLevel = UIWindow.Level.alert
        self.window.rootViewController = hudViewController
        self.window.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    public static func show(message: String? = nil) {
        shared.hudViewController.hudView.messageLabel.text = message
        shared.window.isHidden = false
    }

    public static func hide() {
        shared.window.isHidden = true
    }

    public static func setSpinnerTintColor(_ color: UIColor) {
        shared.hudViewController.hudView.activityIndicator.color = color
    }

    public static func setSpinnerMessageColor(_ color: UIColor) {
        shared.hudViewController.hudView.messageLabel.textColor = color
    }
}

private class HUDView : UIView {
    init() {
        super.init(frame: CGRect.zero)

        backgroundColor = UIColor.white.withAlphaComponent(0.96)
        layer.cornerRadius = 9.0
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        Log("init(coder:)", data: nil, level: .error)
        fatalError("init(coder:) has not been implemented")
    }
}

private class SpinnerHUDView : HUDView {
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    let messageLabel = UILabel()

    override init() {
        super.init()

        activityIndicator.color = UIColor.gray

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: activityIndicator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 34),
            NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            ])

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        addConstraints([
            NSLayoutConstraint(item: messageLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: messageLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -40),
            NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: activityIndicator, attribute: .bottom, multiplier: 1, constant: 19),
            NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -29)
            ])

        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)

        activityIndicator.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        Log("init(coder:)", data: nil, level: .error)
        fatalError("init(coder:) has not been implemented")
    }
}

private class HUDViewController : UIViewController {
    let hudView = SpinnerHUDView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(hudView)
        hudView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: hudView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: hudView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: hudView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 156),
            NSLayoutConstraint(item: hudView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120),
            NSLayoutConstraint(item: hudView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .left, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: hudView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: view, attribute: .right, multiplier: 1, constant: -40)
            ])
    }

    override func viewWillAppear(_ animated: Bool) {
        hudView.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1)
        hudView.layer.opacity = 0.3

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.hudView.layer.transform = CATransform3DIdentity
            self.hudView.layer.opacity = 1
        }, completion: nil)
    }
}
