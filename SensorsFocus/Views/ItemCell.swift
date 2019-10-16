//
//  ItemCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class ItemCell: UITableViewCell {

    @IBOutlet weak var leftProduct: UIView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var leftTag: UIButton!
    @IBOutlet weak var leftContent: UILabel!
    @IBOutlet weak var leftPrice: UILabel!

    @IBOutlet weak var rightProduct: UIView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var rightTag: UIButton!
    @IBOutlet weak var rightContent: UILabel!
    @IBOutlet weak var rightPrice: UILabel!

    var items: [GoodsItem]?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        self.backgroundColor = kUnderColor

        leftProduct.layer.cornerRadius = kCornerRadius
        leftProduct.setShadow()
        leftTag.layer.masksToBounds = true
        leftTag.layer.cornerRadius = 7.5

        let itemSize = (kScreenWidth - 30) / 2.0
        let rect = CGRect.init(x: 0, y: 0, width: itemSize, height: itemSize)
        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: .init(width: kCornerRadius, height: kCornerRadius))
        let leftLayer = CAShapeLayer.init()
        leftLayer.frame = leftImage.bounds
        leftLayer.path = path.cgPath
        leftImage.layer.mask = leftLayer

        rightProduct.layer.cornerRadius = kCornerRadius
        rightProduct.setShadow()
        rightTag.layer.masksToBounds = true
        rightTag.layer.cornerRadius = 7.5

        let rightLayer = CAShapeLayer.init()
        rightLayer.frame = rightImage.bounds
        rightLayer.path = path.cgPath
        rightImage.layer.mask = rightLayer

        let leftTap = UITapGestureRecognizer.init(target: self, action: #selector(productTap))
        leftProduct.addGestureRecognizer(leftTap)

        let rightTap = UITapGestureRecognizer.init(target: self, action: #selector(productTap(_:)))
        rightProduct.addGestureRecognizer(rightTap)
    }

    @objc func productTap(_ gesture: UITapGestureRecognizer) {
        let item = items![gesture.view!.tag]
        let controller = self.managerController()
        let vc = ProductVC.init()
        vc.item = item
        vc.hidesBottomBarWhenPushed = true
        controller?.navigationController?.pushViewController(vc, animated: true)
    }

    func updateItems(array: [GoodsItem]) {
        items = array
        if array.count == 0 {
            leftProduct.isHidden = true
            rightProduct.isHidden = true
            return
        }
        if array.count == 1 {
            leftProduct.isHidden = false
            rightProduct.isHidden = true
        }

        let placeholderText = "                  "

        let left = array.first!
        leftImage.image = UIImage(named: left["icon"]!)
        let leftTagText = left["tag"]
        leftTag.setTitle(leftTagText, for: .normal)
        leftTag.gradientColor(.hex("E5281A"), to: .hex("FF6751"))

        let noTag = leftTagText!.isEmpty
        leftTag.isHidden = noTag
        leftContent.text = "\(noTag ? "" : placeholderText) \(left["content"]!)"
        leftPrice.text = left["price"]!

        if array.count == 2 {
            let right = array[1]

            rightImage.image = UIImage(named: right["icon"]!)
            rightTag.gradientColor(.hex("E5281A"), to: .hex("FF6751"))
            let rightTagText = right["tag"]
            rightTag.setTitle(rightTagText, for: .normal)
            let noTag = rightTagText!.isEmpty
            rightTag.isHidden = noTag
            rightContent.text = "\(noTag ? "" : placeholderText) \(right["content"]!)"
            rightPrice.text = right["price"]!

            leftProduct.isHidden = false
            rightProduct.isHidden = false
        }
    }
}
