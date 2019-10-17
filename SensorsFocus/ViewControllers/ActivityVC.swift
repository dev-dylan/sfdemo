//
//  ActivityVC.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/10/15.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class ActivityVC: UIViewController {

    var urlStr: String?
    var webview: WKWebView!

    static func showActivityScreen(_ controller: UINavigationController, urlStr: String) {
        let activity = ActivityVC.init()
        activity.urlStr = urlStr
        activity.hidesBottomBarWhenPushed = true
        controller.pushViewController(activity, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "领取红包优惠"

        navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "icon_header"), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        webview = WKWebView.init(frame: view.bounds)
        webview.backgroundColor = .clear
        view.addSubview(webview)

        let url = URL.init(string: urlStr ?? "")
        let request = URLRequest.init(url: url!)
        webview.load(request)

        if urlStr == kActivityURL {
            saveCouponFlag(true)
            let properties = ["discount_name": "限时优惠券", "discount_amount": "10.00", "discount_type": "全网活动"]
            Track.track("ReceiveDiscount", properties: properties)

        }

        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        button.setImage(UIImage.init(named: "white_back"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let left = UIBarButtonItem.init(customView: button)
        navigationItem.leftBarButtonItem = left
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
