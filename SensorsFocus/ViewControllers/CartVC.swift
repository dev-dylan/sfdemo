//
//  CartViewController.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit
class CartVC: BaseVC, CartAdapterDelegate {

    var originalTotal = 0.0
    var items = [GoodsItem]()
    var adapter: CartAdapter!
    var isSubVC = false
    var action: CartAction!
    override func viewDidLoad() {
        super.viewDidLoad()
        var height = kScreenHeight - kStatusBarHeught - kTabBarHeight
        height = isSubVC ? height : height - 50
        tableView.frame = .init(x: 0, y: kStatusBarHeught, width: kScreenWidth, height: height)
        adapter = CartAdapter.init(tableView, delegate: self)

        let container = UIView.init()
        container.backgroundColor = .white
        view.addSubview(container)

        container.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(self.isSubVC ? 0 : -kTabBarHeight)
            make.height.equalTo(self.isSubVC ? kTabBarHeight : 50)
        }

        let item = CartAction.instanceItem()
        container.addSubview(item)
        item.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
        item.allSelected.addTarget(self, action: #selector(allSelectedAction(_:)), for: .touchUpInside)
        item.purchase.addTarget(self, action: #selector(purchaseAction(_:)), for: .touchUpInside)
        action = item

        if !isSubVC {
            self.hideCustomBackItem()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateCartItems()
    }

    func updateCartItems() {
        let all = Goods.goodsList()
        var unselected = false
        var total = 0.0
        var allNum = 0
        for item in all {
            if item["select"] == "1" {
                let price = Double(item["price"]!) ?? .nan
                let original = Double(item["original_price"]!) ?? .nan
                let num = Double(item["num"]!) ?? .nan
                total += price * num
                originalTotal += original * num
                allNum += 1
            } else {
                unselected = true
            }
        }
        if all.count == 0 {
            unselected = true
        }

        action.allSelected.isSelected = !unselected
        action.price.text = "￥\(total)"
        action.allText.text = unselected ? "全选" : "取消全选"
        action.purchase.setTitle(allNum > 0 ? "结算(\(allNum))" : "结算", for: .normal)
        adapter.items = all
        adapter.reload()
    }

    @objc func allSelectedAction(_ sender: Any) {
        let all = Goods.goodsList()
        let allSelected = !action.allSelected.isSelected
        action.allSelected.isSelected = allSelected
        for var item in all {
            item["select"] = allSelected ? "1" : "0"
            Goods.updateGoods(item)
        }
        self.updateCartItems()
    }

    @objc func purchaseAction(_ sender: Any) {
        view.show(message: "跳转支付订单")
        var properties = [String: Any]()
        let orderId = NSUUID.init().uuidString
        properties["order_id"] = orderId
        properties["order_amount"] = action.purchase.titleLabel?.text
        properties["order_actual_amount"] = "\(originalTotal)"

        if receivedCoupon() {
            properties["discount_name"] = "限时优惠券"
            properties["discount_amount"] = "10.00"
            properties["discount_type"] = "全网活动"
        }
        properties["if_use_discount"] = receivedCoupon()
        SensorsAnalyticsSDK.sharedInstance()?.track("PayOrder", withProperties: properties)

        let all = Goods.goodsList()
        var total = 0.0
        for item in all where item["select"] == "1" {
            let price = Double(item["price"]!) ?? .nan
            let num = Double(item["num"]!) ?? .nan
            total += price * num

            var pro = [String: Any]()
            pro["order_id"] = orderId
            pro["commodity_id"] = item["goodsId"]
            pro["commodity_name"] = item["content"]
            pro["first_commodity"] = item["first_commodity"]
            pro["second_commodity"] = item["second_commodity"]
            pro["original_price"] = item["original_price"]
            pro["present_price"] =  item["price"]
            pro["commodity_quantity"] =  "\(total)"
            pro["total_price_of_commodity"] =  "\(total)"
            SensorsAnalyticsSDK.sharedInstance()?.track("PayOrderDetail", withProperties: pro)
        }
    }

    func updatedCurrentGoodsItem() {
        self.updateCartItems()
    }
}
