//
//  AppDelegate.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setupSensorsAnalytics(launchOptions)
        self.setupJGPush(launchOptions)
        return true
    }

    func setupSensorsAnalytics(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let serverURL = "http://sf03analyst2.datasink.sensorsdata.cn/sa?project=default&token=59fe187bf5724d84"
        let configOptions = SAConfigOptions.init(serverURL: serverURL, launchOptions: launchOptions)
        configOptions.autoTrackEventType = [.eventTypeAppStart, .eventTypeAppEnd, .eventTypeAppClick, .eventTypeAppViewScreen]
        configOptions.enableTrackAppCrash = true
        SensorsAnalyticsSDK.start(configOptions: configOptions)
        let sdk = SensorsAnalyticsSDK.sharedInstance()
        sdk?.registerSuperProperties(["platform_type": "iOS", "testKey": "testValue"])
        sdk?.registerDynamicSuperProperties({ () -> [String: Any] in
            return ["testRandomNum": Int.random(in: 0...100)]
        })
        sdk?.enableLog(true)
        sdk?.addWebViewUserAgentSensorsDataFlag()
        sdk?.trackInstallation("AppInstall", withProperties: ["testInstall": "testValue"])
        sdk?.enableTrackGPSLocation(true)
        sdk?.enableTrackScreenOrientation(true)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if SensorsAnalyticsSDK.sharedInstance()?.canHandle(url) == true {
            SensorsAnalyticsSDK.sharedInstance()?.handleSchemeUrl(url)
        }
        return false
    }

    func setupJGPush(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity()
        entity.types = 1 << 0 | 1 << 1 | 1 << 2
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        JPUSHService.setup(withOption: launchOptions, appKey: "bbfa3ee756b1b7a4cbf3fc72", channel: "App Store", apsForProduction: false, advertisingIdentifier: advertisingId)
        JPUSHService.registrationIDCompletionHandler { (_, registrationID) in
            SensorsAnalyticsSDK.sharedInstance()?.profilePushKey("jgId", pushId: registrationID ?? "")
        }
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
       let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        //打开推送设置
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        let couponName = userInfo["discount_name"]
        let goodsId = userInfo["goodaId"] as? String
        if couponName != nil && goodsId != nil {
            let goodsList = Goods.goodsList()
            var result = -1
            for index in 0..<goodsList.count {
                let itemId = goodsList[index]["goodsId"]
                if itemId == goodsId {
                    result = index
                }
            }
            if result > -1 {
                var item = goodsList[result]
                item["discount_name"] = "限时优惠券"
                item["discount_amount"] = "10.00"
                item["discount_type"] = "全网活动"
                Goods.updateGoods(item)
            }
        }

        var properties = [String: Any]()
        properties["$sf_msg_title"] = userInfo["sf_msg_title"]
        properties["$sf_msg_content"] = userInfo["sf_msg_content"]
        properties["$sf_link_url"] = userInfo["sf_link_url"]
        properties["$sf_plan_id"] = userInfo["sf_plan_id"]
        properties["$sf_audience_id"] = userInfo["sf_audience_id"]
        properties["$sf_plan_strategy_id"] = userInfo["sf_plan_strategy_id"]
        SensorsAnalyticsSDK.sharedInstance()?.track("AppOpenNotification", withProperties: properties)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
        UIApplication.shared.cancelAllLocalNotifications()
    }

    // MARK: UISceneSession Lifecycle
}
