//
//  JunTranstionPhotoController.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/26.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD
import Kingfisher

class JunTranstionPhotoController: UIViewController {
    // MARK:- 属性
    fileprivate var currentIndex: Int
    fileprivate var imageArray: [ImageModel]?
    fileprivate var transitionType = "cube" //转场动画类型
    fileprivate lazy var progressView : ProgressView = ProgressView()
    fileprivate lazy var baseImage = UIImageView(image: UIImage(named: "coderJun"))
    
    //MARK: 构造方法
    init(images: [ImageModel], currentIndex: Int) {
        self.imageArray = images
        self.currentIndex = currentIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializationViews()
    }

    //初始化界面
    fileprivate func initializationViews(){
        view.backgroundColor = UIColor.black
        
        
        //1. 添加切换效果按钮
        let typeBtn = UIButton(title: "修改展示效果", bgColor: UIColor.darkGray, fontSize: 14)
        typeBtn.frame = CGRect(x: (kScreenWidth - 100) / 2, y: kScreenHeight - 50, width: 100, height: 30)
        typeBtn.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        view.addSubview(typeBtn)
        
        //2. 设置imageView
        baseImage.frame = view.frame
        baseImage.isUserInteractionEnabled = true
        
        //3. 加载图片
        guard let imageURL = URL(string: imageArray![currentIndex].pic74) else { return }
        downloadImage(url: imageURL)
        
        //4. 添加点击手势
        baseImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissImageView)))
        //添加长按手势
        baseImage.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(saveImage(gesture:))))
        
        //5. 添加滑动手势
        let left = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(gesture:)))
        left.direction = .left
        baseImage.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(gesture:)))
        right.direction = .right
        baseImage.addGestureRecognizer(right)
        view.addSubview(baseImage)
    }
}

//MARK: 事件监听
extension JunTranstionPhotoController {
    //消失动画
    @objc fileprivate func dismissImageView(){
        dismiss(animated: true, completion: nil)
    }
    
    //rightButtonItem
    @objc fileprivate func rightButtonAction(){
        let typeView = JunTransitionView(frame: UIScreen.main.bounds)
        typeView.delegate = self
        view.addSubview(typeView)
    }
    
    //左滑
    @objc fileprivate func leftSwipe(gesture: UIGestureRecognizer) {
        transitionAnimation(isNext: true)
    }
    //右滑
    @objc fileprivate func rightSwipe(gesture: UIGestureRecognizer) {
        transitionAnimation(isNext: false)
    }
    
    //设置转场动画
    fileprivate func transitionAnimation(isNext: Bool){
        guard let array = imageArray else { return }
        //1. 当前图片索引
        let index = isNext ? currentIndex + 1 : currentIndex - 1
        
        //2. 越界判断
        if index >= array.count {
            SVProgressHUD.showError(withStatus: "已经是最后一张了")
            return
        }else if index < 0 {
            SVProgressHUD.showError(withStatus: "已经是第一张了")
            return
        }
        
        //3. 修改quanjunt索引值
        currentIndex = index
        
        //3. 获取下/上一张图片的url
        guard let imageURL = URL(string: imageArray![index].pic74) else { return }
        
        //4. 转场动画
        let transition = CATransition()
        transition.type = transitionType
        transition.subtype = isNext ? kCATransitionFromRight : kCATransitionFromLeft
        transition.duration = 1
        downloadImage(url: imageURL)
        baseImage.layer.add(transition, forKey: "transition")
    }
    
    //加载图片
    fileprivate func downloadImage(url: URL){
        //1. 取出小图
        var smallImage = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: url.absoluteString)
        if smallImage == nil {
            smallImage = UIImage(named: "coderJun")
        }
        
        //2.计算imageView的位置和尺寸
        calculateImageFrame(image: smallImage!)
        
        //3. 加载大图
        progressView.isHidden = false
        baseImage.kf.setImage(with: url, placeholder: smallImage, options: [], progressBlock: { (current, total) in
            DispatchQueue.main.async(execute: {
                self.progressView.progress = CGFloat(current) / CGFloat(total)
            })
        }) { (image, _, _, _) in
            if image != nil {
                self.calculateImageFrame(image: image!)
                self.baseImage.image = image
                self.progressView.isHidden = true
            }
        }
    }
    
    /// 计算imageView的frame和显示位置
    fileprivate func calculateImageFrame(image: UIImage) {
        let imageH = image.size.height / image.size.width * kScreenWidth
        baseImage.frame = CGRect(x: 0, y: (kScreenHeight - imageH) / 2, width: kScreenWidth, height: imageH)
    }
    
    //长按图片，保存到相册
    @objc fileprivate func saveImage(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended || gesture.state == .changed {
            let alertV = UIAlertController()
            let saveAction = UIAlertAction(title: "保存图片", style: .default) { (alertV) in
                self.cameraLimits()
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertV.addAction(saveAction)
            alertV.addAction(cancelAction)
            present(alertV, animated: true, completion: nil)
        }
    }
    
    //判断相册权限
    fileprivate func cameraLimits(){
        let state = PHPhotoLibrary.authorizationStatus()
        if state == .restricted || state == .denied {
            let alert = UIAlertController(title: "相册权限已关闭", message: "您未授权相册权限，请在设置中开启权限后执行此操作", preferredStyle: .alert)
            let action = UIAlertAction(title: "去设置", style: .default, handler: { (alert) in
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                self.navigationController?.popViewController(animated: true)
            })
            let cancle = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancle)
            present(alert, animated: true, completion: nil)
        }else{
            //保存图片到相册中
            UIImageWriteToSavedPhotosAlbum(baseImage.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    //保存图片成功
    @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            SVProgressHUD.showError(withStatus: "图片保存失败")
        } else {
            SVProgressHUD.showSuccess(withStatus: "图片保存成功")
        }
    }
}

//MARK: JunBrowserDismissDelegate
extension JunTranstionPhotoController: JunBrowserDismissDelegate{
    func imageViewForDismiss() -> UIImageView {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        
        //设置图片
        imageV.image = baseImage.image
        imageV.frame = baseImage.convert(baseImage.frame, to: UIApplication.shared.keyWindow)
        
        return imageV
    }
    
    func indexPathForDismiss() -> IndexPath {
        return IndexPath(item: currentIndex, section: 0)
    }
}


extension JunTranstionPhotoController: JuntransitionDelegate {
    func tranisitionAnimationType(type: String) {
        transitionType = type
    }
}
