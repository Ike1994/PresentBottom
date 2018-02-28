//
//  TimeSelectVC.swift
//  PresentBottom
//
//  Created by Isaac Pan on 2018/2/28.
//  Copyright © 2018年 Isaac Pan. All rights reserved.
//

import UIKit

final class TimeSelectVC: PresentBottomVC {
    override var controllerHeight: CGFloat {
        return 300
    }
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: controllerHeight-75))
        datePicker.locale = Locale.current
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(timeSelect(sender:)), for: .valueChanged)
        return datePicker
    }()
    lazy var sureButton:UIButton = {
        let button = UIButton(frame: CGRect(x: kScreenWidth-60, y: 0, width: 40, height: 40))
        button.setImage(#imageLiteral(resourceName: "ic_sureButton"), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(sureButtonClicked), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 75, width: kScreenWidth, height: kScreenHeight-75))
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame:CGRect(x: (kScreenWidth-150)/2, y: 20, width: 150, height: 30))
        label.textAlignment = .center
        label.text = "Time Select"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    override public func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    private func config() {
        view.backgroundColor = UIColor.clear
        let roundView = RoundView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 150))
        view.addSubview(roundView)
        roundView.addSubview(titleLabel)
        view.addSubview(containerView)
        view.addSubview(sureButton)
        containerView.addSubview(datePicker)
    }
    @objc func sureButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func timeSelect(sender:UIDatePicker) {
        print("Time change to \(sender.date)")
    }
}
