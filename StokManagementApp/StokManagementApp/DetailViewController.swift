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

    //MARK: - IBOutlet
    @IBOutlet private weak var detailTitle: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - instance
    //titleTextにViewControllerから受け取ったamountArrayのテキストを表示
    var titleText: String?

    //MARK: - public method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //argStringに値が入っていない場合には、後続処理を継続しない
        guard let thisTitleText = titleText else {
            detailTitle.title = "値がない"
            return
        }
        
        //titleにtextの内容を代入して表示
        detailTitle.title = thisTitleText

    }
    
    //MARK: - IBAction
    
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
        //ビューに表示
        imageView.image = image
        //写真を選ぶビューを閉じる
        self.dismiss(animated: true )
    }
}
