//
//  BillsCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/27.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class BillsCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var allBills: UIButton!
    @IBOutlet var operations: [UIView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear

        container.layer.cornerRadius = kCornerRadius
        container.setShadow()

        for item in operations {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(operationTap))
            item.layer.cornerRadius = 10
            item.addGestureRecognizer(tap)
        }
    }

    @objc func operationTap(_ gesture: UITapGestureRecognizer) {
        let array = ["待付款", "待发货", "待收货", "待评价"]
        let index = gesture.view!.tag
        self.managerController()?.view.show(message: array[index])
        }

    @IBAction func allBillsAction(_ sender: Any) {
        self.managerController()?.view.show(message: "查看全部订单")
    }
}
