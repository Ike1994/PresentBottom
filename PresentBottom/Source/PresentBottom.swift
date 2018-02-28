//
//  PresentBottom.swift
//  PresentBottom
//
//  Created by Isaac Pan on 2018/2/28.
//  Copyright © 2018年 Isaac Pan. All rights reserved.
//

import Foundation
import UIKit
public class PresentBottom:UIPresentationController {
    lazy var blackView: UIView = {
        let view = UIView()
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    public var controllerHeight:CGFloat
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        if case let vc as PresentBottomVC = presentedViewController {
            controllerHeight = vc.controllerHeight ?? UIScreen.main.bounds.height
        } else {
            controllerHeight = UIScreen.main.bounds.width
        }
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    public override func presentationTransitionWillBegin() {
        blackView.alpha = 0
        containerView?.addSubview(blackView)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
        }
    }
    public override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
        }
    }
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            blackView.removeFromSuperview()
        }
    }
    public override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: UIScreen.main.bounds.height-controllerHeight, width: UIScreen.main.bounds.width, height: controllerHeight)
    }
    
}

public class PresentBottomVC: UIViewController {
    public var controllerHeight: CGFloat? {
        get {
            return self.controllerHeight
        }
    }
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    public func presentBottom(_ vc: PresentBottomVC.Type) {
        let controller = vc.init()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = PresentBottom(presentedViewController: presented, presenting: presenting)
        return present
    }
}
