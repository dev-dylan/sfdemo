//
//  BaseViewController.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class BaseVC: UIViewController {

    var tableView: UITableView!
    var mask: UIView!
    weak var delegate: UIGestureRecognizerDelegate?
    var barStyle: UIStatusBarStyle?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kUnderColor
        tabBarController?.tabBar.tintColor = .red

        mask = UIImageView.init(image: UIImage.init(named: "icon_header"))
        view.addSubview(mask)
        mask.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        let height = kScreenHeight - kNaviBarHeight - kTabBarHeight
        let frame = CGRect.init(x: 0, y: kNaviBarHeight, width: kScreenWidth, height: height)
        tableView = UITableView.init(frame: frame, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        button.setImage(UIImage.init(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let left = UIBarButtonItem.init(customView: button)
        navigationItem.leftBarButtonItem = left
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.barStyle!
    }

    public func hideCustomBackItem() {
        navigationItem.leftBarButtonItem = nil
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
