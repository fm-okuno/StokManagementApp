//
//  DetailView.swift
//  StokManagementApp
//
//  Created by 開発アカウント on 2020/05/14.
//  Copyright © 2020 開発アカウント. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DetailViewController : UIViewController {

    //MARK: - IBOutlet
    @IBOutlet private weak var uiNavigationItem: UINavigationItem!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - instance
    //titleTextに受け取ったamountArrayのテキストを表示
    var titleText: String?
    //ViewControllerからIDを受け取る
    var stockId: Int?
    let stockModel = StockModel()
    let realm = try! Realm()


    //MARK: - public method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titleTextに値が入っていない場合には、後続処理を継続しない
        guard let thisTitleText = titleText else {
            uiNavigationItem.title = "値がない"
            return
        }

        //titleにtextの内容を代入して表示
        uiNavigationItem.title = thisTitleText
                
        //stockIdが空の場合には後続処理を継続しない
        guard let thisStockId = stockId else {
            print("IDを取得できていません。(\(stockId))")
            return
        }
    
        print("受け取ったIDは\(thisStockId)だよ")

        //正常にデータを取得できていない場合には後続処理を継続しない
        let results = realm.objects(StockModel.self).filter("id == \(thisStockId)").first
        guard let savedImage = results?.amountImage else {
            return
        }
        
        //取得した画像データをUIImage型に変換できない場合には後続処理を継続しない
        guard let thisUiImageData = UIImage(data: savedImage) else {
            return
        }
        
        imageView.image = thisUiImageData
                
    }
    
    //MARK: - private method
    
    //MARK: - IBAction
    
    //写真を保存する為のactionSaveImageButton
    @IBAction private func actionSaveImageButton(_ sender: Any) {
        
        //stockIdが空の場合には後続処理を継続しない
        guard let thisStockId = stockId else {
            print("IDを取得できていません")
            return
        }
        
        //現在表示中の画像データを取得
        //imageView.imageが空の場合には後続処理を継続しない
        guard let showImage = imageView.image else {
            print("写真を正常に取得できていません")
            return
        }
        
        //画像をData型に変換できない場合には後続処理を継続しない
        guard let thisPngImageData = showImage.pngData() else {
            return
        }
        

        let results = realm.objects(StockModel.self).filter("id == \(thisStockId)").first
        try! realm.write {
            results?.amountImage = thisPngImageData
        }
    }
    
    //+ボタンを押下でカメラロールを開き、写真を選択
    @IBAction private func actionSelectImageButton(_ sender: Any) {
            //写真を選ぶビュー
            let pickerView = UIImagePickerController()
            //カメラロールから写真を選択
            pickerView.sourceType = .photoLibrary
            //デリゲート
            pickerView.delegate = self
            //ビューに表示
            self.present(pickerView, animated: true)
        }
    }

//MARK: - extension

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //選択された写真をUIImageViewに表示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        //選択された写真を取得
        let selectedImage = info[.originalImage] as! UIImage
                
        //選択された写真を表示
        imageView.image = selectedImage
        
        //写真を選ぶビューを閉じる
        self.dismiss(animated: true )
    }
}
