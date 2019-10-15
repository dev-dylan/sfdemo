//
//  HomeAdapter.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/26.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

protocol HomeAdapterDelegate: TopicCellDelegate, ItemsAdapterDelegate, BannerCellDelgate {}

class HomeAdapter: BaseAdapter {

    let productSection = 1
    var adapter: ItemsAdapter?
    weak var delegate: HomeAdapterDelegate?

    init(_ tableView: UITableView, delegate: HomeAdapterDelegate) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        customInitialized()
    }
    override func customInitialized() {
        super.customInitialized()
        tableView.delegate = self
        tableView.dataSource = self
        register("CategoriesCell")
        register("ActivitiesCell")
        register("TopicCell")
        register(BannerCell.self, name: "BannerCell")
        adapter = ItemsAdapter.init(tableView, delegate: delegate!)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == productSection {
            return (adapter?.tableView(tableView, numberOfRowsInSection: section))!
        }
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if section == productSection {
            return (adapter?.tableView(tableView, cellForRowAt: indexPath))!
        }

        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell") as? BannerCell
            cell?.delegate = delegate
            return cell!
        }

        if row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell")
            return cell!

        }

        if row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesCell")
            return cell!
        }

        if row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell") as? TopicCell
            cell?.delegate = delegate
            return cell!
        }

        return super.tableView(tableView, cellForRowAt: indexPath)
    }
}
