//
//  MeViewController.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class MeVC: BaseVC, MeAdapterDelegate, LoginSuccessDelegate {

    var adapter: MeAdapter!
    var pop: LoginSuccess?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideCustomBackItem()

        let height = kScreenHeight - kStatusBarHeught - kTabBarHeight
        tableView.frame = .init(x: 0, y: kStatusBarHeught, width: kScreenWidth, height: height)
        adapter = MeAdapter.init(tableView, delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUserInfo()
    }

    func didSelectedHeader() {
        if !isLogin() {
            LoginVC.showLogin(navigationController!, delegate: self)
        }
    }

    func didTriggerLogout() {
        let alert = UIAlertController.init(title: "是否确认退出登录？", message: nil, preferredStyle: .alert)
        let left = UIAlertAction.init(title: "取消", style: .default, handler: nil)
        let right = UIAlertAction.init(title: "确认", style: .default) { (_) in
            saveUsername("")
            saveCouponFlag(false)
            self.reloadUserInfo()
        }
        alert.addAction(left)
        alert.addAction(right)
        self.present(alert, animated: true, completion: nil)
    }

    func loginSuccess() {
        self.reloadUserInfo()
        LoginSuccess.show()
    }

    func reloadUserInfo() {
        adapter.username = currentUsername()
        adapter.reload()
    }
}
