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
    
    func loadImageDatas(page: Int, finishedBack: @escaping ()-> ()) {
        let urlString = "http://qf.56.com/home/v4/moreAnchor.ios"
        let param: [String: Any] = ["type" : 0, "page" : page, "size" : 30]
        JunNetworkTool.requestData(.get, URLString: urlString, parameters: param) { (result) in
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            
            for (index, dict) in dataArray.enumerated() {
                let anchor = ImageModel(dict: dict)
                anchor.isEvenIndex = index % 3
                self.imageArray.append(anchor)
            }
            
            finishedBack()
        }
    }
}
