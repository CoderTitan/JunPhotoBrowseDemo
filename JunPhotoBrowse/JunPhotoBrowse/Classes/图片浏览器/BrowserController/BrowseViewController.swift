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
    fileprivate lazy var closeBtn = UIButton(title: "关闭", bgColor: UIColor.darkGray, fontSize: 14)
    fileprivate lazy var saveBtn = UIButton(title: "保存", bgColor: UIColor.darkGray, fontSize: 14)
    
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
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2.布局子控件
        let btnHMargin : CGFloat = 20
        let btnVMargin : CGFloat = 10
        let btnW : CGFloat = 100
        let btnH : CGFloat = 32
        closeBtn.frame = CGRect(x: btnHMargin, y: view.bounds.height - btnH - btnVMargin, width: btnW, height: btnH)
        saveBtn.frame = CGRect(x: view.bounds.width - PicMargin - btnW - btnHMargin, y: view.bounds.height - btnVMargin - btnH, width: btnW, height: btnH)
        collectionView.frame = view.bounds
        
        // 3.监听按钮的点击
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        
        // 4.准备collectionView的属性
        collectionView.dataSource = self
        collectionView.register(BrowseCollectionCell.self, forCellWithReuseIdentifier: PhotoCellID)
    }
}

//MARK: 事件监听
extension BrowseViewController {
    @objc fileprivate func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    //保存图片
    @objc fileprivate func saveBtnClick(){
        //1. 获取cell
        guard let cell = collectionView.visibleCells[0] as? BrowseCollectionCell else { return }
        
        //2. 取出cell里面的image
        guard let image = cell.imageView.image else { return }
        
        //3. 判断相机权限是否开启
        let state = PHPhotoLibrary.authorizationStatus()
        if state == .restricted || state == .denied {
            let alert = UIAlertController(title: "相册权限已关闭", message: "您未授权相册权限，请在设置中开启权限后执行此操作", preferredStyle: .alert)
            let action = UIAlertAction(title: "去设置", style: .default, handler: { (alert) in
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                self.dismiss(animated: true, completion: nil)
            })
            let cancle = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancle)
            present(alert, animated: true, completion: nil)
        }else{
            //保存图片到相册中
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    //保存图片返回值
    @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            SVProgressHUD.showError(withStatus: "图片保存失败")
        } else {
            SVProgressHUD.showSuccess(withStatus: "图片保存成功")
        }
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
        closeBtnClick()
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
