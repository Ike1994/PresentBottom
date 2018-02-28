//
//  ViewController.swift
//  PresentBottom
//
//  Created by Isaac Pan on 2018/2/28.
//  Copyright © 2018年 Isaac Pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func showButtonClicked(_ sender: UIButton) {
        self.presentBottom(FirstBottomVC.self)
    }
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        self.presentBottom(SelectionVC.self)
    }
    @IBAction func timeButtonClicked(_ sender: UIButton) {
        self.presentBottom(TimeSelectVC.self)
    }
}

