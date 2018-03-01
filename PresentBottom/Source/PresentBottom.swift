//
//  PresentBottom.swift
//  PresentBottom
//
//  Created by Isaac Pan on 2018/2/28.
//  Copyright © 2018年 Isaac Pan. All rights reserved.
//

import Foundation
import UIKit

/// use an instance to show the transition
public class PresentBottom:UIPresentationController {
    
    /// black layer
    lazy var blackView: UIView = {
        let view = UIView()
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    /// value to control height of bottom view
    public var controllerHeight:CGFloat
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        //get height from an objec of PresentBottomVC class
        if case let vc as PresentBottomVC = presentedViewController {
            controllerHeight = vc.controllerHeight ?? UIScreen.main.bounds.height
        } else {
            controllerHeight = UIScreen.main.bounds.width
        }
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    /// add blackView to the container and let alpha animate to 1 when show transition will begin
    public override func presentationTransitionWillBegin() {
        blackView.alpha = 0
        containerView?.addSubview(blackView)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
        }
    }
    
    /// let blackView's alpha animate to 0 when hide transition will begin.
    public override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
        }
    }
    
    /// remove the blackView when hide transition end
    ///
    /// - Parameter completed: completed or no
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            blackView.removeFromSuperview()
        }
    }
    
    /// define the frame of bottom view
    public override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: UIScreen.main.bounds.height-controllerHeight, width: UIScreen.main.bounds.width, height: controllerHeight)
    }
    
}

/// a base class of vc to write bottom view
public class PresentBottomVC: UIViewController {
    public var controllerHeight: CGFloat? {
        get {
            return self.controllerHeight
        }
    }
}

// MARK: - add function to UIViewController to call easily
extension UIViewController: UIViewControllerTransitioningDelegate {
    
    /// function to show the bottom view
    ///
    /// - Parameter vc: class name of bottom view
    public func presentBottom(_ vc: PresentBottomVC.Type) {
        let controller = vc.init()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    // function refers to UIViewControllerTransitioningDelegate
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = PresentBottom(presentedViewController: presented, presenting: presenting)
        return present
    }
}
