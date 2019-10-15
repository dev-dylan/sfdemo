//
//  ProductHeaderCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/30.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class ProductHeaderCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle =  .none
    }
}
