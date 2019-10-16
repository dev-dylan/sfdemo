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
        sdk?.enableLog(false)
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
            self.trackSFAppNotification(userInfo)
        }
        completionHandler()
    }

    func trackSFAppNotification(_ userInfo: [AnyHashable: Any]) {
        var properties = [String: Any]()
        let string = userInfo["sf_data"] as? String
        let data = string?.data(using: .utf8)
        var urlStr = ""
        do {
            let json = try JSONSerialization.jsonObject(with: data ?? Data.init(), options: .mutableContainers)
            let dic = json as? [String: Any]
            properties["$sf_plan_id"] = dic?["sf_plan_id"]
            properties["$sf_plan_name"] = dic?["sf_plan_name"]
            properties["$sf_audience_id"] = dic?["sf_audience_id"]
            properties["$sf_plan_strategy_id"] = dic?["sf_plan_strategy_id"]
            if dic?["$sf_landing_type"] as? String == "LINK" {
                properties["$sf_link_url"] = dic?["sf_link_url"]
                urlStr = (dic?["sf_link_url"] as? String)!
            }
            let custom = properties["customized"]
            if custom is [String: Any] {
                //处理自定义字段
            }
        } catch _ {
            print("透传消息解析数据失败")
        }
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"]
        if alert is [String: Any] {
            let newAlert = alert as? [String: Any]
            properties["$sf_msg_title"] = newAlert?["title"]
            properties["$sf_msg_content"] = newAlert?["body"]
        } else if alert is String {
            properties["$sf_msg_content"] = alert
        }
        SensorsAnalyticsSDK.sharedInstance()?.track("AppOpenNotification", withProperties: properties)

        if !urlStr.isEmpty {
            let root = self.window?.rootViewController as? UITabBarController
            let navc = root?.viewControllers![root!.selectedIndex] as? UINavigationController
            ActivityVC.showActivityScreen(navc!, urlStr: urlStr)
        }
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        //打开推送设置
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
