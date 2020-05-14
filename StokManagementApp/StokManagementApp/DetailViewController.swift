//
//  DetailView.swift
//  StokManagementApp
//
//  Created by 開発アカウント on 2020/05/14.
//  Copyright © 2020 開発アカウント. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController {
    
    //在庫情報を表示する為のargString(テスト用)
    var argString: String?
    
    @IBOutlet private weak var detailTitle: UINavigationItem!
    @IBOutlet private weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //argStringに値が入っていない場合には、「値がないよ」と表示させる
        if argString == nil {
            argString = "値がないよ"
        }
        
        //titleとlabelにargStringの内容を代入して表示
        detailLabel.text = argString
        detailTitle.title = argString
    }
}
