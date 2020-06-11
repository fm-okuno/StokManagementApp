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
    
    //削除フラグのないレコードの件数を取得
    func getRealmRecodeValue() -> Int {
        let realm = try! Realm()
        let results = realm.objects(StockModel.self).filter("deleteFlag == false")
        let intResults = results.count
        return intResults
    }
    
    //セルに表示する文字列を生成するcreateCellData
    func createCellData() -> [String] {
        let realm = try! Realm()
        var resultArray = [""]
        let getDataQuery = realm.objects(StockModel.self).filter("deleteFlag == false")
        for data in getDataQuery {
            resultArray += ["数量：\(data.amount)登録日時：\(data.createDate)コメント：\(data.comment ?? "")"]
        }
        return resultArray
    }
    
    //セルからデータを取り出す為のgetRealmRecodeData
    func getRealmRecodeData(fromIndexRow: Int) -> Results<StockModel> {
        let realm = try! Realm()
        let results = realm.objects(StockModel.self).filter("id == '\(fromIndexRow)'")
        return results
    }
}
