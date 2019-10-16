//
//  HomeViewController.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

class HomeVC: BaseVC, HomeAdapterDelegate, LoginSuccessDelegate {

    var adapter: HomeAdapter!
    var activityToLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideCustomBackItem()

        adapter = HomeAdapter.init(tableView, delegate: self)

        let container = UIView.init(frame: .init(x: 0, y: 0, width: kScreenWidth - 20, height: 30))
        container.layer.cornerRadius = 15
        container.backgroundColor = .white

        let search = UIImageView.init(image: UIImage.init(named: "search"))
        search.frame = CGRect.init(x: 15, y: 8, width: 14, height: 14)
        container.addSubview(search)

        let text = UILabel.init(frame: .init(x: 35, y: 8, width: 240, height: 14))
        //TODO: 修改文字
        text.text = "国庆假期出行热搜"
        text.font = .systemFont(ofSize: 13)
        text.textColor = .lightGray
        container.addSubview(text)

        let photos = UIImageView.init(image: UIImage.init(named: "photos"))
        photos.isUserInteractionEnabled = true
        photos.frame = .init(x: kScreenWidth - 20 - 30, y: 8, width: 14, height: 14)
        container.addSubview(photos)
        let photoTap = UITapGestureRecognizer.init(target: self, action: #selector(photosTap))
        photos.addGestureRecognizer(photoTap)

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(searchTap))
        container.addGestureRecognizer(tap)

        navigationController?.navigationBar.topItem?.titleView = container
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adapter.reload()
    }

    //action methods
    @objc func photosTap() {
        view.show(message: "点击相机")
    }

    @objc func searchTap() {
        view.show(message: "点击搜索框")
    }

    //delgate methods
    func didSelectedTopic(index: Int) {
        adapter.adapter?.shuffle()
    }

    func didSelectedBanner(_ itemId: String) {
        if itemId == isLoginId {
            LoginVC.showLogin(navigationController!, delegate: self)
        }

        if itemId == isActivitiyId {
            if isLogin() {
                self.showActivityScreen()
            } else {
                activityToLogin = true
                LoginVC.showLogin(navigationController!, delegate: self)
            }
        }

        var item: GoodsItem?
        for sub in Goods.fakeGoodsList() {
            //TODO: referrer 字段替换
            let subId = sub["goodsId"]
            if subId == itemId {
                item = sub
                item?["referrer"] = "banner"
            }
        }
        if item != nil {
            let vc = ProductVC.init()
            vc.item = item
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func loginSuccess() {
        adapter.reload()
        if activityToLogin {
            self.showActivityScreen()
        }
    }

    //custom mehtods
    func showActivityScreen() {
        ActivityVC.showActivityScreen(navigationController!, urlStr: kActivityURL)
    }
}
