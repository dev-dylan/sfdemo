//
//  CartAction.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/10/9.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class CartAction: UIView {

    @IBOutlet weak var purchaseContainer: UIView!
    @IBOutlet weak var allSelected: UIButton!
    @IBOutlet weak var freight: UILabel!
    @IBOutlet weak var total: UILabel!
    //渐变色
    @IBOutlet weak var purchase: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var allText: UILabel!
    static func instanceItem() -> CartAction {
        let view = Bundle.main.loadNibNamed("CartAction", owner: nil, options: nil)?.first as? CartAction
        return view!
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        purchase.gradientColor(.hex("E5281A"), to: .hex("FF6751"))
    }
}
