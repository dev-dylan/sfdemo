//
//  TopicCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

protocol TopicCellDelegate: NSObjectProtocol {
    func didSelectedTopic(index: Int)
}

class TopicCell: UITableViewCell {

    @IBOutlet var containers: [UIView]!
    @IBOutlet var titles: [UILabel]!
    @IBOutlet var descs: [UIButton]!
    var selectedIndex = 0
    weak var delegate: TopicCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = kUnderColor
        for container in containers {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(containerTap))
            container.addGestureRecognizer(tap)
        }
        let desc = descs[0]
        desc.gradientColor(.init(hexString: "E5281A"), to: .init(hexString: "FF6751"))
    }

    @objc func containerTap(_ gesture: UITapGestureRecognizer) {
        let selected = gesture.view!.tag

        for index in 0..<titles.count {
            let title = titles[index]
            title.textColor = (selected == index ? .init(hexString: "DD422F") : .init(hexString: "1F2D3D"))
        }

        for index in 0..<descs.count {
            let desc = descs[index]
            if selected == index {
                desc.gradientColor(.init(hexString: "E5281A"), to: .init(hexString: "FF6751"))
            } else {
                desc.gradientColor( kUnderColor, to: kUnderColor)
            }
            desc.setTitleColor((selected == index ? .white : .init(hexString: "5E6D82")), for: .normal)
        }

        delegate?.didSelectedTopic(index: selected)
        print(titles[selected].text!)
    }
}
