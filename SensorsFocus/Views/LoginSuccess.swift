//
//  LoginSuccess.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/10/11.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class LoginSuccess: UIView {

    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var toHome: UIButton!
    static func instanceItem() -> LoginSuccess {
        let view = Bundle.main.loadNibNamed("LoginSuccess", owner: nil, options: nil)?.first as? LoginSuccess
        view?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view!
    }

    @IBAction func closeAction(_ sender: Any) {
        self.removeFromSuperview()
    }
}
