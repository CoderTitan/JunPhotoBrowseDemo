//
//  BrowseCollectionCell.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/25.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoBrowserCellDelegate : NSObjectProtocol {
    func photoBrowserCellImageClick()
}

class BrowseCollectionCell: UICollectionViewCell {
    // MARK:- 懒加载属性
    fileprivate lazy var progressView : ProgressView = ProgressView()
    lazy var imageView = UIImageView()
    lazy var scrollView = UIScrollView()
    // 代理属性
    var delegate : PhotoBrowserCellDelegate?
    var imageURL: URL? {
        didSet{
            guard let url = imageURL else { return }
            
            //1. 取出小图
            var smallImage = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: url.absoluteString)
            if smallImage == nil {
                smallImage = UIImage(named: "coderJun")
            }
            
            //2.计算imageView的位置和尺寸
            calculateImageFrame(image: smallImage!)
            
            //3. 加载大图
            progressView.isHidden = false
            imageView.kf.setImage(with: url, placeholder: smallImage, options: [], progressBlock: { (current, total) in
                DispatchQueue.main.async(execute: {
                    self.progressView.progress = CGFloat(current) / CGFloat(total)
                })
            }) { (image, _, _, _) in
                if image != nil {
                    self.calculateImageFrame(image: image!)
                    self.imageView.image = image
                    self.progressView.isHidden = true
                }
            }
        }
    }
    
    /// 计算imageView的frame和显示位置
    fileprivate func calculateImageFrame(image: UIImage) {
        let imageH = image.size.height / image.size.width * kScreenWidth
        imageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: imageH)
//        imageView.addLongPressSaveImage()
        scrollView.contentSize = CGSize(width: kScreenWidth, height: imageH)
        
        //判断是长图还是短图
        if imageH < kScreenHeight {
            //设置偏移量
            let topInset = (kScreenHeight - imageH) / 2
            scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        }else{
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializationViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BrowseCollectionCell {
    //初始化界面
    fileprivate func initializationViews(){
        // 1.添加子控件
        //添加scrollView的目的是为了可以让图片进行缩放(两个手指拖动图片缩放)
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(progressView)
        
        // 2.设置子控件的位置
        scrollView.frame = bounds
        scrollView.frame.size.width -= 20
        progressView.backgroundColor = UIColor.clear
        progressView.isHidden = true
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: contentView.bounds.width * 0.5 - 10, y: contentView.bounds.height * 0.5)
        
        // 4.设置scrollView的代理
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.7
        scrollView.maximumZoomScale = 1.5
        
        // 5.给imageView添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(closePhototBrowser))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func closePhototBrowser(){
        delegate?.photoBrowserCellImageClick()
    }
}


//MARK:
extension BrowseCollectionCell: UIScrollViewDelegate{
    // 返回将要缩放的UIView对象。要执行多次
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /*
     * 当缩放结束后，并且缩放大小回到minimumZoomScale与maximumZoomScale之间后（我们也许会超出缩放范围），调用该方法
     * view : 被缩放的视图
     * scale : 当前缩放的比例
     */
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        var topInset = (scrollView.bounds.height - view!.frame.height) / 2
        topInset = topInset < 0 ? 0 : topInset
        
        var leftInset = (scrollView.bounds.width - view!.frame.width) / 2
        leftInset = leftInset < 0 ? 0 : leftInset
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: 0, right: 0)
    }
    
    //当scrollView缩放时，调用该方法。在缩放过程中，回多次调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 当缩小到一定比例,则自动退出控制器
        
    }
}
