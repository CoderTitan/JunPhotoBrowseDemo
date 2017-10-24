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
        let itemWH = (kScreenWidth - (col + 1) * margin) / 3
        
        //3. 设置布局
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = margin
        minimumInteritemSpacing = margin
        
        //4. 设置内边距
        collectionView?.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
    }
}
