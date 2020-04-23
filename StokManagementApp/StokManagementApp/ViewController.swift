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
    
    @IBOutlet weak var amountLabel: UILabel!
    var intAmount: Int = 0
    
    @IBAction private func actionChangeAmountButton(_ sender: UIStepper) {
        //UIStepperの値をDoubleからIntに変換し、intAmountに代入
        intAmount = Int(sender.value)
        
        //3桁毎にカンマで区切る設定
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        //intAmountをNSNumber型に変換
        let nsAmount = NSNumber(value: intAmount)
        //変換したnsAmountに3桁区切りの設定を適用
        let addCommaAmount = formatter.string(from: nsAmount)
        
        //カンマで区切ったStepperの値をamountLabel.textに代入して表示
        amountLabel.text = addCommaAmount
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

