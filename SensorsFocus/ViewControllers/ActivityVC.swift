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
        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            //TODO: ios 11 以下测试
            self.edgesForExtendedLayout = .all
        }
        view.addSubview(webview)

        let url = URL.init(string: urlStr ?? "")
        let request = URLRequest.init(url: url!)
        webview.load(request)

        if urlStr == kActivityURL {
            saveCouponFlag(true)
            let properties = ["discount_name": "限时优惠券", "discount_amount": "10.00", "discount_type": "全网活动"]
            Track.track("ReceiveDiscount", properties: properties)

        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
}
