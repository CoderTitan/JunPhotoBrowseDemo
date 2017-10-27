//
//  BrowseViewController.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/24.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit
import Photos
import Kingfisher
import SVProgressHUD

fileprivate let PhotoCellID = "PhotoCellID"
fileprivate let PicMargin : CGFloat = 20 /// 图片间距

class BrowseViewController: UIViewController {

    // MARK:- 属性
    fileprivate var currentIndexPath: IndexPath
    fileprivate var imageArray: [ImageModel]?
    // MARK:- 懒加载子控件
    fileprivate lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoCollectionViewLayout())
    
    //MARK: 构造方法
    init(images: [ImageModel], currentIndexP: IndexPath) {
        self.imageArray = images
        self.currentIndexPath = currentIndexP
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width += PicMargin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializationViews()
        
        // .滚到指定位置
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
}

// 设置子控件
extension BrowseViewController {
    fileprivate func initializationViews(){
        // 1.添加子控件
        view.addSubview(collectionView)
        
        // 2.布局子控件
        collectionView.frame = view.bounds
        
        // 4.准备collectionView的属性
        collectionView.dataSource = self
        collectionView.register(BrowseCollectionCell.self, forCellWithReuseIdentifier: PhotoCellID)
    }
}


//MARK: 自定义FlowLayout
extension BrowseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellID, for: indexPath) as? BrowseCollectionCell else {
            return UICollectionViewCell()
        }
        
        let imageURL = URL(string: imageArray![indexPath.item].pic74)
        cell.imageURL = imageURL
        cell.delegate = self
        
        // 3.自动下载下一张图片
        downloadNextImage(index: indexPath.item + 1)
        
        return cell
    }
    
    //自动加载下一张图片
    fileprivate func downloadNextImage(index: Int){
        // 1.判断是否有下一张图片
        if index >= imageArray!.count {
            return
        }
        
        //2.下载
        let url = URL(string: imageArray![index].pic74)!
        KingfisherManager.shared.downloader.downloadImage(with: url)
    }
}

//MARK: PhotoBrowserCellDelegate
extension BrowseViewController: PhotoBrowserCellDelegate{
    func photoBrowserCellImageClick() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: JunBrowserDismissDelegate
extension BrowseViewController: JunBrowserDismissDelegate{
    func imageViewForDismiss() -> UIImageView {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        
        //设置图片
        guard let cell = collectionView.visibleCells[0] as? BrowseCollectionCell else { return UIImageView() }
        imageV.image = cell.imageView.image
        imageV.frame = cell.scrollView.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow)
        
        return imageV
    }
    
    func indexPathForDismiss() -> IndexPath {
        return collectionView.indexPathsForVisibleItems[0]
    }
}


//MARK: 自定义FlowLayout
class PhotoCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.布局属性设置
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
    }
}
