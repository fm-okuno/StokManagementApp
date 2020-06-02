//
//  ViewController.swift
//  StokManagementApp
//
//  Created by 開発アカウント on 2020/04/23.
//  Copyright © 2020 開発アカウント. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class ViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Property クラスで使用する変数やインスタンス
    private var amount = 0
    private var amountArray: [String] = []
    //Timerをインスタンス化
    private let timer = Timer()
    //時刻のデータを入れる為のtimerData
    private var timerData = ""
    //入力された在庫数を入れる為のinputAmountArray
    private var inputAmountArray: [Int] = []
    //選択されたセルの合計値を保存する為のadditionAmountValue
    private var sumAmount = 0
    //セグエで受け渡す変数
    private var sendText: String?
    //セグエで受け渡すid
    private var sendStockId: String?
    //Realm
    private let realm = try! Realm()
    //StockModelのインスタンス化
    private let stockModel = StockModel()
    
    private var tableCell = UITableViewCell()
    
    //MARK: - public method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //1秒毎にshowNowTimeメソッドを実行する
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(self.showNowTime),
                             userInfo: nil,
                             repeats: true
        )
    }
    
    //segueで遷移時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "toDetailViewController" else {
            return
        }
        
        guard let detailVC = (segue.destination as? DetailViewController) else {
            return
        }
        
        //detailVCのtitleTextにamountArrayを入れた変数を指定
        detailVC.titleText = sendText
    }
    
    //MARK: - IBAction
    //クリアボタン押下で配列を空にして画面を更新する事でリストを全件削除
    @IBAction private func actionAmountClearButton(_ sender: UIButton) {
        
        amountArray = []
        inputAmountArray = []
        //在庫の合計値も初期化
        sumAmount = 0
        
        tableView.reloadData()
    }
        
    //追加ボタン
    @IBAction private func actionAddStockButton(_ sender: UIButton) {
        
        //String型のamountDataにamountLabelの値を代入
        //amountDataがnilの場合には後続処理を継続しない
        guard let amountData = amountLabel.text else {
            return
        }
                
        //timeDataにHH:mm:ssに整形済みの現在時刻を代入
        //timeDataがnilの場合には後続処理を継続しない
        guard let timeData = timeLabel.text else {
            return
        }
        
        //commentDataにテキスト入力欄の文字列を代入
        //commentDataがnilの場合には後続処理を継続しない
        guard let commentData = commentTextField.text else {
            return
        }

        //amountArrayにString形式で各データを保存
        amountArray += [("数量：\(judgeInputExistence(amountData))　時刻：\(timeData)　コメント：\(commentData)")]
        
        //カンマのついていない在庫数をinputAmountArrayに追加
        inputAmountArray.append(amount)

        //DBにデータを追加（現在は追加できたかの確認のためにprintで出力）
        print(stockModel.addStockData(amount: amount, comment: commentData, amountImage: nil, createDate: timeData))
            
        //追加ボタン押下で選択が全解除される為、一度sumAmountを初期化
        sumAmount = 0
        
        //テーブルを更新
        tableView.reloadData()
    }
    
    //数量を入力する為のactionChangeAmountButton
    @IBAction private func actionChangeAmountButton(_ sender: UIStepper) {
        //UIStepperからの値を変数amountに代入
        amount = Int(sender.value)
        
        //addCommaメソッドを使いカンマ区切りの設定をし、amountLabelのtextに代入して表示
        amountLabel.text = convertAmountToString(amount)
    }
    
    //選択されたセルの合計数量を表示する
    @IBAction private func actionShowSelectedTotalValueButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "計算結果", message: "合計\(sumAmount)です",
            preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "OK",
                                   style: UIAlertAction.Style.default,
                                   handler: nil)
        
        alert.addAction(action)
        
        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - private method
    
    //Int型の値を受け取り、3桁毎にカンマで区切る「addComma」メソッド
    private func convertAmountToString(_ forValue: Int) -> String? {
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

//在庫数が入力されているか判定し、未入力であれば0を、入力されていればその値を代入する
private func judgeInputExistence(_ forString: String) -> String {
    var valueAssignedString = ""
    if forString == "数量9,999" {
        valueAssignedString = "0"
        return valueAssignedString
    } else {
        valueAssignedString = forString
        return valueAssignedString
    }
}

//MARK: - extension
//extensinを用いてセルの生成部分を分割
extension ViewController : UITableViewDelegate {
    
    //セル削除の許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //セルがスワイプされた際の動作
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 詳細ボタンのアクションを設定
        //詳細ボタンを押下で詳細詳細画面へ遷移
        let shareAction = UIContextualAction(style: .normal  , title: "詳細") {
            (ctxAction, view, completionHandler) in
            
            //sendTextに詳細ボタンが押された行に表示されているamountArrayの値を代入
            self.sendText = self.amountArray[indexPath.row]
            self.performSegue(withIdentifier: "toDetailViewController", sender: nil)
            
            completionHandler(true)
        }
        
        // 削除のアクションを設定する
        let deleteAction = UIContextualAction(style: .destructive, title:"削除") {
            (ctxAction, view, completionHandler) in
            
            //削除ボタンが押された行のデータを配列から削除
            self.amountArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        // スワイプでの削除を無効化して設定する
        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction, shareAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
        
    }
    
    //セル選択時の動作
    //複数選択可能、選択されたセルの値をsumAmountに加算
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
        sumAmount += inputAmountArray[thisCellTag]
    }
    
    //セル選択解除時の動作
    //セルの背景色を元の色に戻し、チェックマークを削除。選択解除されたセルの在庫分をマイナス
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //cellがnullなら後続処理を継続しない
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        //選択解除されたセルの在庫分をマイナス
        sumAmount -= inputAmountArray[cell.tag]
        
        cell.accessoryType = .none
        
        //セル生成時と同じ条件で再度色を設定（元の色に戻す）
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .systemRed
        } else {
            cell.backgroundColor = .systemBlue
        }
    }
}

extension ViewController : UITableViewDataSource {
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
}
