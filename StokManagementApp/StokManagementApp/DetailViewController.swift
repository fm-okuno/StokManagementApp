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
    //PrimaryKeyを受け取る
    var stockId: String?
    //写真を保存しておく為のuserDefaults
    let userDefaults = UserDefaults.standard
    let stockModel = StockModel()
    let realm = try! Realm()


    //MARK: - public method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //argStringに値が入っていない場合には、後続処理を継続しない
        guard let thisTitleText = titleText else {
            uiNavigationItem.title = "値がない"
            return
        }
        
        //titleにtextの内容を代入して表示
        uiNavigationItem.title = thisTitleText
    }
    
    //MARK: - private method
    
    //MARK: - IBAction
    
    //写真を保存する為のactionSaveImageButton
    @IBAction private func actionSaveImageButton(_ sender: Any) {
        //現在表示中の画像データを取得
        //imageView.imageが空の場合には後続処理を継続しない
        guard let thisImage = imageView.image else {
            return
        }
        
        let imageData = thisImage.pngData()
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
        let image = info[.originalImage] as! UIImage

        //選択された写真を表示
        imageView.image = image
        
        //写真を選ぶビューを閉じる
        self.dismiss(animated: true )
    }
}
