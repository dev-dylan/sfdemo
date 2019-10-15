//
//  CartAdapter.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/26.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

protocol CartAdapterDelegate: ItemsAdapterDelegate, CartItemCellDelegate {}

class CartAdapter: BaseAdapter {

    let productSection = 1
    var adapter: ItemsAdapter?
    weak var delegate: CartAdapterDelegate?
    var items = [GoodsItem]()

    init(_ tableView: UITableView, delegate: CartAdapterDelegate) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        customInitialized()
    }

    override func customInitialized() {
        tableView.delegate = self
        tableView.dataSource = self
        register("CartItemCell")
        register("CartHeaderCell")
        adapter = ItemsAdapter.init(tableView, delegate: delegate!)
        adapter?.showHeader = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == productSection {
            return (adapter?.tableView(tableView, numberOfRowsInSection: section))!
        }
        return 1 + (items.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == productSection {
            return (adapter?.tableView(tableView, cellForRowAt: indexPath))!
        }

        if indexPath.row == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "CartHeaderCell")) as? CartHeaderCell
            cell?.desc.text = "共\(Goods.goodsList().count)件宝贝"
            return cell!
        }

        let cell = (tableView.dequeueReusableCell(withIdentifier: "CartItemCell")) as? CartItemCell
        cell?.updateGoodsInfo(items[indexPath.row - 1])
        cell?.delegate = delegate
        return cell!
    }
}
