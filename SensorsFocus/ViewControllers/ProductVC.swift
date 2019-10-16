//
//  ProductVC.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/30.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

class ProductVC: BaseVC, ProductAdapterDelegate {

    var item: GoodsItem?
    var adapter: ProductAdapter?
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var addCart: UIButton!
    @IBOutlet weak var purchase: UIButton!
    init() {
        super.init(nibName: "ProductVC", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mask?.isHidden = true
        tableView.frame = .init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kTabBarHeight)
        adapter = ProductAdapter.init(tableView, delegate: self)
        adapter?.item = item
        adapter?.reload()
        view.backgroundColor = .white

        purchase.layer.cornerRadius = 17.5
        purchase.layer.masksToBounds = true
        purchase.gradientColor(.hex("FFBA01"), to: .hex("FFA602"))

        addCart.layer.cornerRadius = 17.5
        addCart.layer.masksToBounds = true
        addCart.gradientColor(.hex("E5281A"), to: .hex("FF6751"))

        number.layer.masksToBounds = true
        number.layer.cornerRadius = 7.5
        number.layer.borderColor = UIColor.red.cgColor
        number.layer.borderWidth = 0.5
        number.text = "\(Goods.goodsList().count)"

        view.bringSubviewToFront(container)
        let rightButton = UIButton.init(type: .custom)
        rightButton.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        rightButton.setImage(UIImage.init(named: "more"), for: .normal)
        rightButton.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        let right = UIBarButtonItem.init(customView: rightButton)
        self.navigationItem.rightBarButtonItem = right

        var properties = self.trackPorperties()
        properties["screen_source"] = item!["referrer"] != nil ? item!["referrer"] : "feed"
        Track.track("CommodityDetail", properties: properties)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    func trackPorperties() -> [String: Any] {
        var properties = [String: Any]()
        properties["commodity_id"] = item?["goodsId"]
        properties["commodity_name"] = item?["content"]
        properties["first_commodity"] = item?["first_commodity"]
        properties["second_commodity"] = item?["second_commodity"]
        properties["original_price"] = item?["original_price"]
        properties["present_price"] = item?["price"]
        return properties
    }

    @objc func moreAction() {
        view.show(message: "查看更多信息")
    }

    @IBAction func storeAction(_ sender: Any) {
        view.show(message: "查看店铺")
    }

    @IBAction func cartAction(_ sender: Any) {
        let cart = CartVC.init()
        cart.isSubVC = true
        navigationController?.pushViewController(cart, animated: true)
    }

    @IBAction func purchaseAction(_ sender: Any) {
        view.show(message: "立即购买")
        var properties = [String: Any]()
        let orderId = NSUUID.init().uuidString
        properties["order_id"] = orderId
        properties["order_amount"] = item!["price"]
        properties["order_actual_amount"] = item!["original_price"]
        properties["if_use_discount"] = false
        Track.track("PayOrder", properties: properties)

        var pro = self.trackPorperties()
        pro["order_id"] = orderId
        pro["commodity_quantity"] = "1"
        pro["total_price_of_commodity"] = item!["price"]
        Track.track("PayOrderDetail", properties: pro)
    }

    @IBAction func addCartAction(_ sender: Any) {
        var newItem = item
        newItem!["select"] = "0"
        Goods.addGoods(newItem!)
        view.show(message: "已加入购物车")
        number.text = "\(Goods.goodsList().count)"
        var properties = self.trackPorperties()
        properties["commodity_quantity"] = number.text
        Track.track("AddToShoppingCart", properties: properties)
    }
}
