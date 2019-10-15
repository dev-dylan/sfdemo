//
//  Goods.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/27.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation

public typealias GoodsItem = [String: String]

class Goods {

    static let goodsKey = "com.sensorsdata.sensorsfocus.goods"

    public static func fakeGoodsList() -> [GoodsItem] {
        let path = Bundle.main.path(forResource: "fake", ofType: "json")
        let data = NSData.init(contentsOfFile: path!)
        let array = try? JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [GoodsItem]
        return array!
    }

    public static func goodsList() -> [GoodsItem] {
        let array = UserDefaults.standard.array(forKey: goodsKey)
        return (array as? [GoodsItem]) ?? [GoodsItem]()
    }

    public static func addGoods(_ goodsItem: GoodsItem) {
        var goods = goodsItem
        var list = self.goodsList()
        var idx = -1
        for index in 0..<list.count {
            let item = list[index]
            if item["goodsId"] == goods["goodsId"] {
                let num = Int(item["num"]!)! + 1
                goods["num"] = "\(num)"
                idx = index
            }
        }
        if idx > -1 {
            list[idx] = goods
        } else {
            goods["num"] = "1"
            goods["select"] = "0"
            list.append(goods)
        }
        UserDefaults.standard.set(list, forKey: goodsKey)
        UserDefaults.standard.synchronize()
    }

    public static func removeGoods(_ goodsItem: GoodsItem) {
        if goodsItem["goodsId"] == nil {
            return
        }
        var list = self.goodsList()
        var idx = -1
        for index in 0..<list.count {
            let item = list[index]
            if goodsItem["goodsId"] == item["goodsId"] {
                idx = index
            }
        }
        if idx > -1 {
            list.remove(at: idx)
        }
        UserDefaults.standard.set(list, forKey: goodsKey)
        UserDefaults.standard.synchronize()
    }

    public static func updateGoods(_ goodsItem: GoodsItem) {
        if goodsItem["goodsId"] == nil {
            return
        }
        var list = self.goodsList()
        var idx = -1
        for index in 0..<list.count {
            let item = list[index]
            if goodsItem["goodsId"] == item["goodsId"] {
                idx = index
            }
        }
        if idx == -1 {
            return
        }
        list[idx] = goodsItem
        UserDefaults.standard.set(list, forKey: goodsKey)
        UserDefaults.standard.synchronize()
    }
}
