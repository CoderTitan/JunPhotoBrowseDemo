//
//  ImageViewModel.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/24.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class ImageViewModel: NSObject {

    lazy var imageArray = [ImageModel]()
    var dataCount = 0  //每一次请求回来的数据个数
    
    func loadImageDatas(page: Int, finishedBack: @escaping ()-> ()) {
        let urlString = "http://qf.56.com/home/v4/moreAnchor.ios"
        let param: [String: Any] = ["type" : 0, "page" : page, "size" : 30]
        JunNetworkTool.requestData(.get, URLString: urlString, parameters: param) { (result) in
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            self.dataCount = dataArray.count
            for (index, dict) in dataArray.enumerated() {
                let anchor = ImageModel(dict: dict)
                anchor.isEvenIndex = index % 3
                self.imageArray.append(anchor)
            }
            
            finishedBack()
        }
    }
}
