//
//  CategoriesCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class CategoriesCell: UITableViewCell {

    @IBOutlet var containers: [UIView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = kUnderColor
        for container in containers {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(containerTap))
            container.addGestureRecognizer(tap)
        }
    }

    @objc func containerTap(_ gesture: UITapGestureRecognizer) {
        let titles = ["数码电器", "生活日用", "美妆穿搭", "生活旅行", "百货生鲜"]
        let index = gesture.view!.tag
        print(titles[index])
        Placeholder.showPlaceholder(self.managerController()!)
    }
}
