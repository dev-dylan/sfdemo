//
//  ItemsAdapter.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

protocol ItemsAdapterDelegate: NSObjectProtocol {}

class ItemsAdapter: BaseAdapter {

    var showHeader = false
    var items = [[GoodsItem]]()
    weak var delegate: ItemsAdapterDelegate?

    init(_ tableView: UITableView, delegate: ItemsAdapterDelegate) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        customInitialized()
    }

    override func customInitialized() {
        super.customInitialized()
        register("ItemCell")
        register("FavoriteCell")
        initItems(list: Goods.fakeGoodsList())
    }

    func initItems(list: [GoodsItem]) {
        var item = [GoodsItem]()
        for index in 0..<list.count {
            let col = index % 2
            item.append(list[index])
            if col != 0 {
                items.append(item)
                item = [GoodsItem]()
            }
        }
        if item.count > 0 {
            items.append(item)
        }
    }

    public func shuffle() {
        let list = Goods.fakeGoodsList().shuffle()
        items = [[GoodsItem]]()
        self.initItems(list: list)
        self.reload()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showHeader ? 1 + items.count : items.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if !showHeader {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell
            cell?.updateItems(array: items[indexPath.row])
            return cell!
        }

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell")
            return cell!
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell
        cell?.updateItems(array: items[indexPath.row - 1])
        return cell!
    }
}
