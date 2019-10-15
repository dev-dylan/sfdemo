//
//  BaseAdapter.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class BaseAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!

    public func customInitialized() {
        //override in subclass
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        register(UITableViewCell.self, name: "UITableViewCell")
    }

    public func reload() {
        tableView.reloadData()
    }

    public func register(_ name: String) {
        let nib = UINib.init(nibName: name, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: name)
    }

    public func register(_ cellClass: AnyClass?, name: String) {
        tableView.register(cellClass, forCellReuseIdentifier: name)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
    }
}
