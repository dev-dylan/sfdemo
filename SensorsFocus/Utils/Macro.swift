//
//  Macro.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/25.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kStatusBarHeught = UIApplication.shared.statusBarFrame.height
let kNaviBarHeight = kStatusBarHeught + 44.0
let isIphoneX = kStatusBarHeught >= 44.0
let kTabBarHeight: CGFloat = isIphoneX ? 34.0 + 49.0 : 49.0

let kUnderColor = UIColor.hex("F8F8F8")
let kCornerRadius: CGFloat = 8.5
