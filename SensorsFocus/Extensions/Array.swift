//
//  Array.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/29.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation

extension Array {

    public func shuffle() -> [GoodsItem] {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex)
            }
        }
        return (list as? [GoodsItem])!
    }
}
