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

class ActivityVC: BaseVC {

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

        webview = WKWebView.init(frame: view.bounds)
        webview.backgroundColor = .clear
        view.addSubview(webview)

        let url = URL.init(string: urlStr ?? "")
        let request = URLRequest.init(url: url!)
        webview.load(request)

        //TODO: 判断是否为活动页面
        saveCouponFlag(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
}
