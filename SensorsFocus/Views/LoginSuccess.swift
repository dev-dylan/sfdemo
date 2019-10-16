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

    static func show() {
        pop.isHidden = false
    }

    static func instanceItem() -> LoginSuccess {
        let view = Bundle.main.loadNibNamed("LoginSuccess", owner: nil, options: nil)?.first as? LoginSuccess
        view?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
        view?.isHidden = true
        let window = UIApplication.shared.keyWindow
        window?.addSubview(view!)
        view?.toHome.addTarget(view, action: #selector(toHomeAction), for: .touchUpInside)
        view?.close.addTarget(view, action: #selector(closeAction), for: .touchUpInside)
        view?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view!
    }

    @objc func toHomeAction() {
        self.isHidden = true
        let root = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
        root?.selectedIndex = 0
    }

    @objc func closeAction() {
        self.isHidden = true
    }
}

var pop = LoginSuccess.instanceItem()
