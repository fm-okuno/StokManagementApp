//
//  ViewController.swift
//  StokManagementApp
//
//  Created by 開発アカウント on 2020/04/23.
//  Copyright © 2020 開発アカウント. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet private  weak var amountLabel: UILabel!
    private var amount: Int = 0
    
    //Int型の値を受け取り、3桁毎にカンマで区切る「addComma」メソッド
    private func addComma(_ forValue: Int) -> String? {
        //3桁毎にカンマで区切る設定
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        //amountをNSNumber型に変換
        let nsAmount = NSNumber(value: amount)
        //変換したnsAmountに3桁区切りの設定を適用
        let addCommaAmount = formatter.string(from: nsAmount)
        
        //戻り値としてカンマで区切られたaddCountAmountを返す
        return addCommaAmount
    }
    
    @IBAction private func actionChangeAmountButton(_ sender: UIStepper) {
        //UIStepperからの値を変数amountに代入
        amount = Int(sender.value)
        
        //addCommaメソッドを使いカンマ区切りの設定をし、amountLabelのtextに代入して表示
        amountLabel.text = addComma(amount)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

