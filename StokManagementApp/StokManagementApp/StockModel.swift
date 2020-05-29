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
    static func create(realm: Realm, asDummy: Bool = false) -> StockModel {
        if asDummy {
            let newDummyStockModel = StockModel()
            newDummyStockModel.id = StockModel.newID(realm: realm)
            return newDummyStockModel
        } else {
            let lastID = (realm.objects(StockModel.self).sorted(byKeyPath: "id").last?.id)!
            let dummyStockModel = realm.object(ofType: StockModel.self, forPrimaryKey: lastID)!
            let newDummyStockModel = StockModel.create(realm: realm, asDummy: true)
            try! realm.write {
                realm.add(newDummyStockModel)
            }
            return dummyStockModel
        }
    }
}


