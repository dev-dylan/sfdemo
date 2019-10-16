//
//  ProductContentCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/30.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class ProductContentCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var tagText: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle =  .none
        tagText.gradientColor(.hex("E5281A"), to: .hex("FF6751"))
    }
    @IBAction func favorite(_ sender: Any) {

    }
}
