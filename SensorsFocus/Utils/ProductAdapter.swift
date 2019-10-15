//
//  ProductAdapter.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/10/8.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

protocol ProductAdapterDelegate: NSObjectProtocol {}

class ProductAdapter: BaseAdapter {

    var item: GoodsItem?
    weak var delegate: ProductAdapterDelegate?

    init(_ tableView: UITableView, delegate: ProductAdapterDelegate) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        customInitialized()
    }

    override func customInitialized() {
        super.customInitialized()
        tableView.delegate = self
        tableView.dataSource = self
        self.register("ProductHeaderCell")
        self.register("ProductContentCell")
        self.register("ProductSkuCell")
        self.register("ProductDetailCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductHeaderCell") as? ProductHeaderCell
            cell?.icon.image = UIImage.init(named: (item?["icon"])!)
            return cell!
        }

        if row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductContentCell")! as? ProductContentCell
            cell?.price.text = item?["price"]
            let tagText = item?["tag"]
            cell?.tagText.setTitle(tagText, for: .normal)
            let placeholderText = "                  "
            let noTag = tagText!.isEmpty
            cell?.tagText.isHidden = noTag
            cell?.content.text = "\(noTag ? "" : placeholderText) \(item?["content"]! ?? "")"
            return cell!
        }

        if row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSkuCell") as? ProductSkuCell
            cell?.sku.text = item?["sku"]
            return cell!
        }

        let cell = (tableView.dequeueReusableCell(withIdentifier: "ProductDetailCell")) as? ProductDetailCell
        cell?.icon.image = UIImage.init(named: item!["large_icon"]!)
        return cell!
    }
}
