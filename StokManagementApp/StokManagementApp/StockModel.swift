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
    //プライマリキーを設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //IDをincrementして返す
    static func newID(realm: Realm) -> Int {
        if let stockModel = realm.objects(StockModel.self).sorted(byKeyPath: "id").last {
            return stockModel.id + 1
        } else {
            return 1
        }
    }
    //incrementされたIDを持つ新規stockModelインスタンスを返す
    //一度使用されたIDは再利用されない
    static func create(realm: Realm, asDummy: Bool = false) -> StockModel {
        if asDummy {
            let newDummyStockModel: StockModel = StockModel()
            newDummyStockModel.id = StockModel.newID(realm: realm)
            return newDummyStockModel
        } else {
            let lastID: Int = (realm.objects(StockModel.self).sorted(byKeyPath: "id").last?.id)!
            let dummyStockModel: StockModel = realm.object(ofType: StockModel.self, forPrimaryKey: lastID)!
            let newDummyStockModel: StockModel = StockModel.create(realm: realm, asDummy: true)
            try! realm.write {
                realm.add(newDummyStockModel)
            }
            return dummyStockModel
        }
    }
}
