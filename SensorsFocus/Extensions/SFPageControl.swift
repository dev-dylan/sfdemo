//
//  SFPageControl.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/10/14.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class SFPageControl: UIPageControl {
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    func updateDots() {
        for index in 0..<subviews.count {
            let dot = subviews[index]
            dot.backgroundColor = .clear
            var item: UIView
            if dot.subviews.count == 0 {
                item = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 16, height: 6))
                item.layer.cornerRadius = 3
                item.layer.masksToBounds = true
                dot.addSubview(item)
            } else {
                item = dot.subviews.first!
            }
            if index == currentPage {
                item.frame = .init(x: 0, y: 0, width: 16, height: 6)
                item.backgroundColor = .init(white: 1, alpha: 0.6)
            } else {
                item.frame = .init(x: 3, y: 1, width: 10, height: 5)
                item.backgroundColor = .init(white: 1, alpha: 0.4)
            }
        }
    }
}
