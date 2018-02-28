//
//  FirstBottomVC.swift
//  PresentBottom
//
//  Created by Isaac Pan on 2018/2/28.
//  Copyright © 2018年 Isaac Pan. All rights reserved.
//

import UIKit

final class FirstBottomVC: PresentBottomVC {
    lazy var closeButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 15, y: 30, width: 80, height: 30))
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        return button
    }()
    override var controllerHeight: CGFloat? {
        return 200
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(closeButton)
    }
    @objc func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
