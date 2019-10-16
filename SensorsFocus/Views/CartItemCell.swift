//
//  CartItemCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/26.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

protocol CartItemCellDelegate: NSObjectProtocol {
    func updatedCurrentGoodsItem()
}

class CartItemCell: UITableViewCell {

    @IBOutlet weak var shadowContent: UIView!
    @IBOutlet weak var storeSelect: UIButton!
    @IBOutlet weak var storeName: UIButton!

    @IBOutlet weak var itemSelect: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var sku: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var reduce: UIButton!
    @IBOutlet weak var number: UILabel!

    @IBOutlet weak var couponContainer: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var activitiesDesc: UILabel!
    @IBOutlet weak var couponHeight: NSLayoutConstraint!

    var goodsItem: GoodsItem?
    weak var delegate: CartItemCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
        shadowContent.layer.cornerRadius = kCornerRadius
        shadowContent.setShadow()

        tagLabel.layer.borderColor = UIColor.hex("E04531").cgColor
        tagLabel.layer.borderWidth = 0.5

        contentContainer.layer.cornerRadius = kCornerRadius
        contentContainer.layer.masksToBounds = true
    }

    func updateGoodsInfo(_ item: GoodsItem) {
        goodsItem = item
        let isSelected = item["select"] == "1"
        storeSelect.isSelected = isSelected
        itemSelect.isSelected = isSelected
        icon.image = UIImage.init(named: item["icon"]!)
        content.text = item["content"]
        price.text = "￥ \(item["price"] ?? "0")"
        sku.setTitle(item["sku"], for: .normal)
        number.text = item["num"]
        if item["num"] == "1" {
            reduce.isEnabled = false
            reduce.setTitleColor(.lightGray, for: .normal)
        }
        self.updateCoupon(isSelected)
    }

    @IBAction func addAction(_ sender: Any) {
        let num = Int(number.text!)! + 1
        number.text = "\(num)"
        reduce.isEnabled = true
        reduce.setTitleColor(.black, for: .normal)
        goodsItem!["num"] = number.text
        Goods.updateGoods(goodsItem!)
        delegate.updatedCurrentGoodsItem()
    }

    @IBAction func reduceAction(_ sender: Any) {
        let num = Int(number.text!)! - 1
        if num == 1 {
            reduce.isEnabled = false
            reduce.setTitleColor(.lightGray, for: .normal)
        }
        if num < 1 {
            return
        }
        number.text = "\(num)"
        goodsItem!["num"] = number.text
        Goods.updateGoods(goodsItem!)
        delegate.updatedCurrentGoodsItem()
    }

    @IBAction func skuAction(_ sender: Any) {
        self.managerController()?.view.show(message: "选择SKU属性")
        print("选择SKU属性")
    }

    @IBAction func itemSelectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        storeSelect.isSelected = sender.isSelected
        goodsItem!["select"] = sender.isSelected ? "1" : "0"
        Goods.updateGoods(goodsItem!)
        self.updateCoupon(sender.isSelected)
        delegate.updatedCurrentGoodsItem()
    }

    @IBAction func storeSelectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        itemSelect.isSelected = sender.isSelected
        goodsItem!["select"] = sender.isSelected ? "1" : "0"
        Goods.updateGoods(goodsItem!)
        self.updateCoupon(sender.isSelected)
        delegate.updatedCurrentGoodsItem()
    }

    @IBAction func storeDetailAction(_ sender: Any) {
        self.managerController()?.view.show(message: "点击店铺名称")
    }

    @IBAction func couponAction(_ sender: Any) {

        if receivedCoupon() {
            self.managerController()?.view.show(message: "已领取成功，请勿重复领取")
            return
        }

        saveCouponFlag(true)
        let properties = ["discount_name": "限时优惠券", "discount_amount": "10.00", "discount_type": "全网活动"]
        SensorsAnalyticsSDK.sharedInstance()?.track("ReceiveDiscount", withProperties: properties)
        delegate.updatedCurrentGoodsItem()
        let navc = self.managerController()?.navigationController
        ActivityVC.showActivityScreen(navc!, urlStr: "https://pro.jd.com/mall/active/3PsCKhiZ1HFKXuTtNsWdu1qmgbJ5/index.html?jd_pop=e0a18aea-c5ad-42a5-a6cb-7854c12ddb6f&utm_source=www.jd.com&utm_medium=zssc&utm_campaign=t_0_&utm_term=e0a18aea-c5ad-42a5-a6cb-7854c12ddb6f-p_132524")
    }

    func updateCoupon(_ hasCoupon: Bool) {
        let received = receivedCoupon() && hasCoupon
        couponHeight.constant = received ? 40.0 : 0.0
        couponContainer.isHidden = !received
        contentContainer.backgroundColor = received ? .hex("F9F9F9") : .white
        self.layoutIfNeeded()
    }
}
