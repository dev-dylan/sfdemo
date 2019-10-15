//
//  CartHeader.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/26.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class CartHeaderCell: UITableViewCell {

    @IBOutlet weak var desc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
}
