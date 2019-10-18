//
//  Track.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/10/16.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation

class Track {

    static func setupSensorsAnalytics(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
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
        sdk?.enableVisualizedAutoTrack()
        sdk?.enableHeatMap()
    }

    static func login(_ name: String) {
        SensorsAnalyticsSDK.sharedInstance()?.login(name)
    }

    static func track(_ event: String, properties: [String: Any]) {
        SensorsAnalyticsSDK.sharedInstance()?.track(event, withProperties: properties)
    }
}
