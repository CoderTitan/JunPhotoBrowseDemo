//
//  HomeCollectionViewLayout.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/24.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class HomeCollectionViewLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        //1. 自定义间距和列数
        let margin: CGFloat = 10
        let col: CGFloat = 3
        
        //2. 计算宽高
        let itemW = (kScreenWidth - (col + 1) * margin) / 3
        let itemH = itemW / 510 * 740
        
        //3. 设置布局
        itemSize = CGSize(width: itemW, height: itemH)
        minimumLineSpacing = margin
        minimumInteritemSpacing = margin
        
        // 设置内边距(在此处设置内边距会与刷新功能冲突, 可选用代理方法实现)
//        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
