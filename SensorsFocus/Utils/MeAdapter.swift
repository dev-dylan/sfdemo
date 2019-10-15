//
//  MeAdapter.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/27.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

protocol MeAdapterDelegate: ItemsAdapterDelegate {
    func didSelectedHeader()
    func didTriggerLogout()
}

class MeAdapter: BaseAdapter, AvatarCellDelegate {

    let productSection = 1
    var adapter: ItemsAdapter?
    weak var delegate: MeAdapterDelegate?
    public var username: String?

    init(_ tableView: UITableView, delegate: MeAdapterDelegate) {
        super.init()
        self.tableView = tableView
        self.delegate = delegate
        customInitialized()
    }

    override func customInitialized() {
        tableView.delegate = self
        tableView.dataSource = self
        register("AvatarCell")
        register("BillsCell")
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
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == productSection {
            return (adapter?.tableView(tableView, cellForRowAt: indexPath))!
        }

        if indexPath.row == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "AvatarCell")) as? AvatarCell
            cell?.delegate = self
            cell?.nickname.text = username ?? "神策用户"
            cell?.logout.isHidden = username == nil
            return cell!
        }
        return (tableView.dequeueReusableCell(withIdentifier: "BillsCell"))!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            delegate?.didSelectedHeader()
        }
    }

    func didTriggerLogout() {
        delegate?.didTriggerLogout()
    }
}
