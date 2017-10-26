//
//  MainViewController.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/26.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "左跳", style: .done, target: self, action: #selector(leftButtonAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "右跳", style: .done, target: self, action: #selector(rightButtonAction))
    }
    
    @IBAction func circleOfFriendAction(_ sender: Any) {
        navigationController?.pushViewController(JunScrollViewController(), animated: true)
    }
    
    @IBAction func customeAction(_ sender: Any) {
        navigationController?.pushViewController(TransitionViewController(), animated: true)
    }
}

//MARK: 事件监听
extension MainViewController {
    @objc fileprivate func leftButtonAction(){
        
    }
    
    @objc fileprivate func rightButtonAction(){
        
    }
    
    /*
     case fullScreen
     
     @available(iOS 3.2, *)
     case pageSheet
     
     @available(iOS 3.2, *)
     case formSheet
     
     @available(iOS 3.2, *)
     case currentContext
     
     @available(iOS 8.0, *)
     case popover
     //以上几种效果都是一样的: 视图从下向上弹出
     
     
     @available(iOS 8.0, *)
     case overFullScreen
     
     @available(iOS 8.0, *)
     case overCurrentContext
     //这两种动画上没有区别，但是之前的viewcontroller的会被放在下面，不会被移除。
     
     @available(iOS 7.0, *)
     case custom
     //custom类型的话，需要用户自己去重写动画，利用`UIViewControllerContextTransitioning`协议
     */
}

