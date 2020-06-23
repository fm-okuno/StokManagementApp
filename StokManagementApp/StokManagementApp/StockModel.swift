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
    @objc dynamic var deleteFlag = false
     
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
    static func create() -> StockModel {
        let realm = try! Realm()
        let stockModel = StockModel()
        stockModel.id = newID(realm: realm)
        return stockModel
    }
    
    //DBにデータを追加する為のaddStockDataメソッド
    func addStockData(amount: Int, comment: String?, amountImage: Data?, createDate: String) {
        let realm = try! Realm()
        let addStockData = StockModel.create()
        addStockData.amount = amount
        addStockData.comment = comment
        addStockData.amountImage = amountImage
        addStockData.createDate = createDate
        try! realm.write {
            realm.add(addStockData)
        }
        print(addStockData)
    }
    
    //DBの全データを取得するgetAllメソッド
    func getAll() -> [StockModel] {
        let realm = try! Realm()
        let results = realm.objects(StockModel.self).filter("deleteFlag == false").sorted(byKeyPath: "id")
        var stocks: [StockModel] = []
        for stock in results {
            stocks.append(stock)
        }
        return stocks
    }
}
