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
        title = "图片列表"
        
        //添加刷新控件
        imageCollection.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadFirstPageData))
        imageCollection.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        imageCollection.mj_header.beginRefreshing()
        imageCollection.mj_footer.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

//MARK: 数据加载
extension MainViewController {
    //下拉刷新
    @objc fileprivate func loadFirstPageData(){
        page = 0
        if imageCollection.mj_footer.isRefreshing {
            imageCollection.mj_footer.endRefreshing()
        }
        imageVM.loadImageDatas(page: 0) {
            self.imageCollection.mj_footer.isHidden = self.imageVM.imageArray.count == 0
            self.imageCollection.reloadData()
            self.imageCollection.mj_header.endRefreshing()
        }
    }
    
    //上啦加载
    @objc fileprivate func loadMoreData(){
        page += 1
        if imageCollection.mj_header.isRefreshing {
            imageCollection.mj_header.endRefreshing()
        }
        imageVM.loadImageDatas(page: page) {
            if self.imageVM.dataCount < 30 {
                self.imageCollection.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.imageCollection.mj_footer.resetNoMoreData()
            }
            self.imageCollection.reloadData()
            self.imageCollection.mj_footer.endRefreshing()
        }
    }
}


//MARK: collection代理
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
