//
//  AvatarCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/27.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

protocol AvatarCellDelegate: NSObjectProtocol {
    func didTriggerLogout()
}

class AvatarCell: UITableViewCell {

    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var logout: UIButton!
    weak var delegate: AvatarCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }

    @IBAction func logoutAction(_ sender: Any) {
        delegate.didTriggerLogout()
    }
}
