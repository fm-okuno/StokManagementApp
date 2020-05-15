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
    
    //TitleにViewControllerから受け取ったamountArrayのテキストを表示
    var titleText: String?
    
    @IBOutlet private weak var detailTitle: UINavigationItem!
//    @IBOutlet private weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //argStringに値が入っていない場合には、「値がないよ」と表示
        if titleText == nil {
            titleText = "値がないよ"
        }
        
        //titleにtextの内容を代入して表示
        detailTitle.title = titleText
    }
}
