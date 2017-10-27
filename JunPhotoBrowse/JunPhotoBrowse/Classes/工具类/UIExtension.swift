//
//  UIExtension.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/24.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD

/// 屏幕的宽
let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕的高
let kScreenHeight = UIScreen.main.bounds.size.height


extension UIButton {
    convenience init(title: String, bgColor: UIColor, fontSize: CGFloat) {
        self.init()
        
        backgroundColor = bgColor
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}

//MARK:
extension UIImageView {
    /// 扩展增加长按保存图片方法
    func addLongPressSaveImage() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.saveImage(gesture:))))
    }
    //长按图片，保存到相册
    @objc fileprivate func saveImage(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended || gesture.state == .changed {
            let alertV = UIAlertController()
            let saveAction = UIAlertAction(title: "保存图片", style: .default) { (alertV) in
                self.cameraLimits()
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertV.addAction(saveAction)
            alertV.addAction(cancelAction)
            UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.last?.present(alertV, animated: true, completion: nil)
        }
    }
    
    //判断相册权限
    fileprivate func cameraLimits(){
        let state = PHPhotoLibrary.authorizationStatus()
        if state == .restricted || state == .denied {
            let alert = UIAlertController(title: "相册权限已关闭", message: "您未授权相册权限，请在设置中开启权限后执行此操作", preferredStyle: .alert)
            let action = UIAlertAction(title: "去设置", style: .default, handler: { (alert) in
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                UIApplication.shared.keyWindow?.rootViewController?.navigationController?.popViewController(animated: true)
            })
            let cancle = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancle)
            UIApplication.shared.keyWindow?.rootViewController?.navigationController?.present(alert, animated: true, completion: nil)
        }else{
            //保存图片到相册中
            UIImageWriteToSavedPhotosAlbum(self.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    //保存图片成功
    @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            SVProgressHUD.showError(withStatus: "图片保存失败")
        } else {
            SVProgressHUD.showSuccess(withStatus: "图片保存成功")
        }
    }
}



