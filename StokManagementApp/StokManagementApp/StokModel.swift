//
//  StokModel.swift
//  StokManagementApp
//
//  Created by 開発アカウント on 2020/05/21.
//  Copyright © 2020 開発アカウント. All rights reserved.
//

import Foundation
import RealmSwift

class StokModel: Object {
    //idには被りが発生することがないよう、UUIDを設定
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var amount: Int = 0
    @objc dynamic var comment: String? = nil
    @objc dynamic var amountImage: Data? = nil
    @objc dynamic var createDate: String = ""
    //プライマリキーを設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
