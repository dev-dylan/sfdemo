//
//  Store.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/10/16.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation

func isLogin() -> Bool {
    let username = UserDefaults.standard.object(forKey: "username") as? String
    return username != nil
}

func currentUsername() -> String {
    let username = UserDefaults.standard.object(forKey: "username") as? String
    return username ?? ""
}

func saveUsername(_ name: String) {
    UserDefaults.standard.set(name, forKey: "username")
    UserDefaults.standard.synchronize()
}

func receivedCoupon() -> Bool {
    return UserDefaults.standard.bool(forKey: "double_eleven_did_received")
}

func saveCouponFlag(_ flag: Bool) {
    UserDefaults.standard.set(flag, forKey: "double_eleven_did_received")
    UserDefaults.standard.synchronize()
}
