//
//  StokModel.swift
//  StokManagementApp
//
//  Created by 開発アカウント on 2020/05/21.
//  Copyright © 2020 開発アカウント. All rights reserved.
//

import Foundation
import RealmSwift

class StockModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var amount = 0
    @objc dynamic var comment: String?
    @objc dynamic var amountImage: Data?
    @objc dynamic var createDate = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //IDをインクリメントして返す
    static func newID(realm: Realm) -> Int {
        if let stockModel = realm.objects(StockModel.self).sorted(byKeyPath: "id").last {
            return stockModel.id + 1
        } else {
            return 1
        }
    }
    
    //インクリメントされたIDを持つ、新規StockModelオブジェクトを返す
        static func create(realm: Realm) -> StockModel {
            let stockModel = StockModel()
            stockModel.id = newID(realm: realm)
            return stockModel
    }
    
    //DBにデータを追加する為のaddStockDataメソッド
    func addStockData(amount: Int, comment: String?, amountImage: Data?, createDate: String) -> StockModel {
        let realm = try! Realm()
        let addStockData = StockModel.create(realm: realm)
        addStockData.amount = amount
        addStockData.comment = comment
        addStockData.amountImage = amountImage
        addStockData.createDate = createDate
        try! realm.write {
            realm.add(addStockData)
        }
        //printで確認するためにaddStockDataを返す
        return addStockData
    }
}
