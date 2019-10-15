//
//  ActivitiesCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class ActivitiesCell: UITableViewCell {

    @IBOutlet weak var shadowContent: UIView!
    @IBOutlet var containers: [UIView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = kUnderColor
        shadowContent.layer.cornerRadius = kCornerRadius
        shadowContent.setShadow()
        //品质生活渐变色
        for item in containers {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(containerTap))
            item.addGestureRecognizer(tap)
        }
    }

    @objc func containerTap(_ gesture: UITapGestureRecognizer) {
        let titles = ["限时半价", "每日红包", "男士用品", "生活家用"]
        let tag = gesture.view!.tag
        print(titles[tag])
        Placeholder.showPlaceholder(self.managerController()!)
    }
}
