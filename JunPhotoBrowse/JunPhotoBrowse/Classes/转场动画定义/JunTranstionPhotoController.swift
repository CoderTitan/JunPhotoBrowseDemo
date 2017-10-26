//
//  JunTranstionPhotoController.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/26.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class JunTranstionPhotoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "右跳", style: .done, target: self, action: #selector(rightButtonAction))

    }

    @objc fileprivate func rightButtonAction(){
        
    }

}
