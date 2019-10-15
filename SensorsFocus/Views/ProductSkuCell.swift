//
//  ProductSkuCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/30.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class ProductSkuCell: UITableViewCell {

    @IBOutlet var items: [UIView]!
    @IBOutlet weak var sku: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle =  .none
        self.backgroundColor = kUnderColor

        for item in items {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
            item.addGestureRecognizer(tap)
        }
    }

    @objc func tapAction(_ gesture: UITapGestureRecognizer) {
        let index = gesture.view!.tag
        if index == 0 {
            self.managerController()?.view.show(message: "选择商品规格")
        } else {
            self.managerController()?.view.show(message: "选择配送地址")
        }
    }
}
