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
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private  weak var amountLabel: UILabel!
    private var amount: Int = 0
    
    //Int型の値を受け取り、3桁毎にカンマで区切る「addComma」メソッド
    private func addComma(_ forValue: Int) -> String? {
        //3桁毎にカンマで区切る設定
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        numFormatter.groupingSeparator = ","
        numFormatter.groupingSize = 3
        
        //amountをNSNumber型に変換
        let nsAmount = NSNumber(value: amount)
        //変換したnsAmountに3桁区切りの設定を適用
        let addCommaAmount = numFormatter.string(from: nsAmount)
        
        //戻り値としてカンマで区切られたaddCountAmountを返す
        return addCommaAmount
    }
    
    @IBAction private func actionChangeAmountButton(_ sender: UIStepper) {
        //UIStepperからの値を変数amountに代入
        amount = Int(sender.value)
        
        //addCommaメソッドを使いカンマ区切りの設定をし、amountLabelのtextに代入して表示
        amountLabel.text = addComma(amount)
        
    }
    
    //Timerをインスタンス化
    var timer = Timer()
    //時刻のデータを入れる為のtimerData
    var timerData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1秒毎にshowNowTimeメソッドを実行する
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.showNowTime),
                                     userInfo: nil,
                                     repeats: true
        )
    }
    
    //取得したデータをHH:mm:ssの形に整形してString型でtimeLabelのtextプロパティに代入する
    //showNowTimeメソッド
    @objc func showNowTime() {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "HH:mm:ss"
        timerData = dateFormatter.string(from: date)
        timeLabel.text = timerData
    }
    
}

