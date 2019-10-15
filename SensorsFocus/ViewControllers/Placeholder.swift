//
//  Placeholder.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/10/10.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class Placeholder: BaseVC {

    static func showPlaceholder(_ controller: UIViewController) {
        let vc = Placeholder.init()
        vc.hidesBottomBarWhenPushed = true
        controller.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel.init(frame: CGRect.init(x: 0, y: 200, width: kScreenWidth, height: 50))
        label.text = "新功能敬请期待"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        view.addSubview(label)
    }
}
