//
//  MainViewController.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/24.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit
import MJRefresh

class MainViewController: UIViewController {

    fileprivate lazy var imageVM = ImageViewModel()
    fileprivate var page = 0 //页数
    @IBOutlet weak var imageCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadFirstPageData()
        
    }
}

//MARK: 数据加载
extension MainViewController {
    fileprivate func loadFirstPageData(){
        page = 0
        imageVM.loadImageDatas(page: 0) {
            self.imageCollection.reloadData()
        }
    }
}


//MARK: collection代理
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageVM.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageModel = imageVM.imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
