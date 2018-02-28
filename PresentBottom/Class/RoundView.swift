//
//  RoundView.swift
//  PresentBottom
//
//  Created by Isaac Pan on 2018/2/28.
//  Copyright © 2018年 Isaac Pan. All rights reserved.
//

import UIKit
public class RoundView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override func draw(_ rect: CGRect) {
        let color = UIColor.white
        color.set()
        let path = UIBezierPath(ovalIn: rect)
        path.fill()
    }
}
