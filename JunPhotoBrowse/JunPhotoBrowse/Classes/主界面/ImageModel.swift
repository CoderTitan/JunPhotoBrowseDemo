//
//  ImageModel.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/24.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class ImageModel: NSObject {

    var name : String = ""
    var pic51 : String = ""
    var pic74 : String = ""
    var isEvenIndex = 0 //第几列
    
    init(dict: [String: Any]) {
        super.init()
        
        name = dict["name"] as? String ?? ""
        pic51 = dict["pic51"] as? String ?? ""
        pic74 = dict["pic74"] as? String ?? ""

    }
    
}
