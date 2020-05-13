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
    
    //MARK: - IBOutlet
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var commentText: UITextField!
    @IBOutlet private weak var myUITable: UITableView!
    
    //MARK: - instance クラスで使用する変数やインスタンス
    private var amount: Int = 0
    private var amountArray: [String] = []
    private var arrayCounter: Int = 0
    //Timerをインスタンス化
    private var timer = Timer()
    //時刻のデータを入れる為のtimerData
    private var timerData: String = ""
    //入力された在庫数を入れる為のinputAmountArray
    private var inputAmountArray: [Int] = []
    //選択されたセルの合計値を保存する為のadditionAmountValue
    private var additionAmountValue: Int = 0

    //MARK: - public method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myUITable.delegate = self
        self.myUITable.dataSource = self
        
        //1秒毎にshowNowTimeメソッドを実行する
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.showNowTime),
                                     userInfo: nil,
                                     repeats: true
        )
    }
    
    //MARK: - IBAction
    //クリアボタン押下で配列を空にして画面を更新する事でリストを全件削除
    @IBAction private func actionAmountClearButton(_ sender: UIButton) {
        amountArray = []
        inputAmountArray = []
        //在庫の合計値も初期化
        additionAmountValue = 0
        myUITable.reloadData()
    }
    
    //セル削除の許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //セルを左にスワイプし、削除ボタンを表示。削除ボタン押下でセルを削除。
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            amountArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            //削除された行の在庫データを削除
            inputAmountArray.remove(at: indexPath.row)
        }
    }

    //追加ボタン
    @IBAction private func actionAddAmountButton(_ sender: UIButton) {
        //String型のamountDataにamountLabelの値を代入
        var amountData: String? = amountLabel.text
        
        //amountDataの値が"数量9,999"（未入力）の場合には、0を代入
        if amountData == "数量9,999" {
            amountData = "0"
            //値が入っている場合には、そのまま変数amountDataに代入
        }
        
        //amountDataがnilの場合には後続処理を継続しない
        guard let thisAmountData = amountData else {
            return
        }
        
        //timeDataにHH:mm:ssに整形済みの現在時刻を代入
        let timeData: String? = timeLabel.text
        //timeDataがnilの場合には後続処理を継続しない
        guard let thisTimeData = timeData else {
            return
        }
        
        //commentDataにテキスト入力欄の文字列を代入
        let commentData: String? = commentText.text
        //commentDataがnilの場合には後続処理を継続しない
        guard let thisCommentData = commentData else {
            return
        }
        
        amountArray += [("数量：\(thisAmountData)　時刻：\(thisTimeData)　コメント：\(thisCommentData)")]
        
        //カンマのついていない在庫数をinputAmountArrayに追加
        inputAmountArray.append(amount)
        
        //追加ボタン押下で選択が全解除される為、一度additionAmountValueを初期化
        additionAmountValue = 0
        
        myUITable.reloadData()
    }
    
    //数量を入力する為のactionChangeAmountButton
    @IBAction private func actionChangeAmountButton(_ sender: UIStepper) {
        //UIStepperからの値を変数amountに代入
        amount = Int(sender.value)
        
        //addCommaメソッドを使いカンマ区切りの設定をし、amountLabelのtextに代入して表示
        amountLabel.text = addComma(amount)
    }
    
    //選択されたセルの合計数量を表示する
    @IBAction private func actionShowSelectedTotalValueButton(_ sender: UIButton) {
        
        let alert: UIAlertController = UIAlertController(title: "計算結果", message: "合計\(additionAmountValue)です",
            preferredStyle: UIAlertController.Style.alert)
        
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK",
                                                         style: UIAlertAction.Style.default,
                                                         handler:{
            // 確定ボタンが押された時の処理
            (action: UIAlertAction) -> Void in
        })
        
        alert.addAction(confirmAction)

        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - private method
    
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
    
    //取得したデータをHH:mm:ssの形に整形してString型でtimeLabelのtextプロパティに代入する
    //showNowTimeメソッド
    @objc private func showNowTime() {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "HH:mm:ss"
        timerData = dateFormatter.string(from: date)
        timeLabel.text = timerData
    }
}

//MARK: - extension
//extensinを用いてセルの生成部分を分割
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    //セルを生成
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //配列の要素の数だけセルを生成
        return amountArray.count
    }
    
    //セルのデータ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        //indexPathが2で割れる時（偶数である場合）には、背景色を赤色にする。
        if indexPath.row % 2 == 0 {
            cell = UITableViewCell(style: .default, reuseIdentifier: "amountCell1")
            cell.backgroundColor = .systemRed
            
        } else {
            //2で割れない場合（奇数である場合）には、背景色を青色にする。
            cell = UITableViewCell(style: .default, reuseIdentifier: "amountCell2")
            cell.backgroundColor = .systemBlue

        }
        
        cell.textLabel?.text = amountArray[indexPath.row]
        //セルに行数のtagをつける
        cell.tag = indexPath.row
        return cell
    }
    
    //セルは複数選択可能。選択時には背景色を黄色にし、チェックマークを付与。
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        cell?.selectionStyle = .none
        cell?.backgroundColor = .yellow
        tableView.allowsMultipleSelection = true
        
        //押下されたセルのtagをindexに指定し、additionAmountValueに在庫をプラス
        guard let thisCellTag = cell?.tag else {
            return
        }
        additionAmountValue += inputAmountArray[thisCellTag]
    }
    
    //セル選択解除時
    //セルの背景色を元の色に戻し、チェックマークを削除。
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //cellがnullなら後続処理を継続しない
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        //選択解除されたセルの在庫分をマイナス
        additionAmountValue -= inputAmountArray[cell.tag]

        cell.accessoryType = .none
        
        //セル生成時と同じ条件で再度色を設定（元の色に戻す）
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .systemRed
        } else {
            cell.backgroundColor = .systemBlue
        }
    }
}
