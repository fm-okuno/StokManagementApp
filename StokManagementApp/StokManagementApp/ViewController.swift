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
    private var stockArray: [String] = []
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
    private var sendStockId: Int = 0
    //Realm
    private let realm = try! Realm()
    //StockModelのインスタンス化
    private let stockModel = StockModel()
    
    private var tableCell = UITableViewCell()
    
    private var stocks: [StockModel] = []
        
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
        //DBの全データをstocksに代入
        stocks = stockModel.getAll()
        
        //アプリ起動時にDBから取得できた項目がある場合
        if stocks.count != 0 {
            for stocksArray in stocks {
                //DBに登録された値からセルに表示する内容を作成
                stockArray += createCellData(amount: stocksArray.amount, comment: stocksArray.comment ?? "", createDate: stocksArray.createDate)
            }
        }
        
        tableView.reloadData()
    }
    
    //segueで遷移時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "toDetailViewController" else {
            return
        }
        
        guard let detailVC = (segue.destination as? DetailViewController) else {
            return
        }
        
        //detailVCに選択されたセルに表示されている内容と、そのセルのIDを送信
        detailVC.titleText = sendText
        detailVC.stockId = sendStockId
        print("detailVCに渡す値は「\(sendText ?? "なし")」と「\(sendStockId)」です")
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

        //DBにデータを追加
        stockModel.addStockData(amount: amount, comment: commentData, amountImage: nil, createDate: timeData)
        
        //追加ボタン押下で選択が全解除される為、一度sumAmountを初期化
        sumAmount = 0
        
        //DBから取得したデータをリセットし、追加データを含めた全データを再取得
        stocks = []
        stocks = stockModel.getAll()
        
        //セルに表示するデータを作成し、stockArrayに追加
        //countを-1しているのは、stocksが0から始まるのに対し、stocks.countが1から始まる為
        stockArray += createCellData(amount: stocks[stocks.count - 1].amount, comment: stocks[stocks.count - 1].comment, createDate: stocks[stocks.count - 1].createDate)
        
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

//セルに表示する内容を作成するcreateCellData
private func createCellData(amount: Int, comment: String?, createDate: String) -> [String] {
    let stockArray = ["数量:\(amount), コメント:\(comment ?? ""), 作成日時:\(createDate)"]
    return stockArray
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
            self.sendText = self.stockArray[indexPath.row]

            //sendStockIdに詳細ボタンが押された行のIDの値を代入
            self.sendStockId = self.stocks[indexPath.row].id

            self.performSegue(withIdentifier: "toDetailViewController", sender: nil)

            completionHandler(true)
        }
        
        //削除のアクションを設定する
        let deleteAction = UIContextualAction(style: .destructive, title:"削除") {
            (ctxAction, view, completionHandler) in
            
            let stockID = self.stocks[indexPath.row].id
            
            //データの削除
            let queryResults = self.realm.objects(StockModel.self).filter("id == \(stockID)").first
            try! self.realm.write {
                queryResults?.deleteFlag = true
            }
            
            //データの更新
            self.stocks = self.stockModel.getAll()
            
            //テーブルの更新
            self.tableView.reloadData()
            
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
        
        //DBの項目の数だけセルを生成
        return stocks.count
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
        
        //DBのデータを文にしてCellのTextLabelに表示
        cell.textLabel?.text = stockArray[indexPath.row]
        
        //セルに行数のtagをつける
        cell.tag = self.stocks[indexPath.row].id
        
        return cell
    }
}
