//
//  FavoriteCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/26.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = kUnderColor
    }
}
