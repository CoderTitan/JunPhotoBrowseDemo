//
//  TransitionViewController.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/26.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit
import MJRefresh
import Kingfisher


class TransitionViewController: UIViewController {
    
    fileprivate var page = 0 //页数
    fileprivate lazy var imageVM = ImageViewModel()
    fileprivate lazy var photoAnimation = PhotoBrowseAnimation()
    @IBOutlet weak var imageCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图片列表"
        
        imageCollection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        //添加刷新控件
        addRefreshView()
    }
    
    fileprivate func addRefreshView(){
        imageCollection.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadFirstPageData))
        imageCollection.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        imageCollection.mj_header.beginRefreshing()
        imageCollection.mj_footer.isHidden = true
    }
}

//MARK: 数据加载
extension TransitionViewController {
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
extension TransitionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        presentPhotoBrowse(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}


// MARK:- 弹出照片浏览器
extension TransitionViewController {
    fileprivate func presentPhotoBrowse(indexPath: IndexPath) {
        //1. 创建图片浏览器
        let photoBrowseVC = BrowseViewController(images: imageVM.imageArray, currentIndexP: indexPath)
        //2. 设置弹出样式为自定义
        photoBrowseVC.modalPresentationStyle = .custom
        //3. 设置转场动画代理
        photoBrowseVC.transitioningDelegate = photoAnimation
        //4. 设置broseAnimation的属性
        photoAnimation.setProperty(indexPath: indexPath, self, photoBrowseVC)
        //5. 弹出图片浏览器
        present(photoBrowseVC, animated: true, completion: nil)
    }
}

//MARK: JunBrowsePresentDelefate
extension TransitionViewController: JunBrowsePresentDelefate {
    func imageForPresent(indexPath: IndexPath) -> UIImageView {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        //设置图片
        imageV.kf.setImage(with: URL(string: imageVM.imageArray[indexPath.item].pic74), placeholder: UIImage(named: "coderJun"))
        return imageV
    }
    
    func startImageRectForpresent(indexPath: IndexPath) -> CGRect {
        // 1.取出cell
        guard let cell = imageCollection.cellForItem(at: indexPath) else {
            return CGRect(x: imageCollection.bounds.width * 0.5, y: kScreenHeight + 50, width: 0, height: 0)
        }
        
        // 2.计算转化为UIWindow上时的frame
        return imageCollection.convert( cell.frame, to: UIApplication.shared.keyWindow)
    }
    
    func endImageRectForpresent(indexPath: IndexPath) -> CGRect {
        //1. 取出对应的image的url
        let imageUrl = URL(string: imageVM.imageArray[indexPath.item].pic74)!
        
        //2.从缓存中取出image
        var image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: imageUrl.absoluteString)
        if image == nil {
            image = UIImage(named: "coderJun")
        }
        
        // 3.根据image计算位置
        let imageH = kScreenWidth / image!.size.width * image!.size.height
        let y: CGFloat = imageH < kScreenHeight ? (kScreenHeight - imageH) / 2 : 0
        
        return CGRect(x: 0, y: y, width: kScreenWidth, height: imageH)
    }
}


