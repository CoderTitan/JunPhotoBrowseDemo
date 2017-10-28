//
//  PhotoBrowseAnimation.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/25.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

//MARK: 自定义协议
protocol JunBrowsePresentDelefate: NSObjectProtocol {
    /// 1. 提供弹出的imageView
    func imageForPresent(indexPath: IndexPath) -> UIImageView
    
    /// 2. 提供弹出的imageView的frame
    func startImageRectForpresent(indexPath: IndexPath) -> CGRect
    
    /// 3.提供弹出后imageView的frame
    func endImageRectForpresent(indexPath: IndexPath) -> CGRect
}

protocol JunBrowserDismissDelegate {
    /// 1.提供推出的imageView
    func imageViewForDismiss() -> UIImageView
    
    /// 2. 提供推出的indexPath
    func indexPathForDismiss() -> IndexPath
}

//
class PhotoBrowseAnimation: NSObject {
    //MARK: 定义变量
    /// 用于记录是弹出动画还是销毁动画
    var isPresent = false
    var indexPath: IndexPath?
    var presentDelegate: JunBrowsePresentDelefate?
    var dismissDelegate: JunBrowserDismissDelegate?
    
    
    /// 定义快速设置属性的函数
    func setProperty(indexPath: IndexPath, _ presentDelgate: JunBrowsePresentDelefate, _ dismissDelegate: JunBrowserDismissDelegate){
        self.indexPath = indexPath
        self.presentDelegate = presentDelgate
        self.dismissDelegate = dismissDelegate
    }
}

//MARK: UIViewControllerTransitioningDelegate
extension PhotoBrowseAnimation: UIViewControllerTransitioningDelegate {
    // 该方法是告诉系统,弹出动画交给谁来处理
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }

    // 该方法是告诉系统,消失动画交给谁来处理
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}


//MARK: 继承AnimatedTransitioning协议
extension PhotoBrowseAnimation: UIViewControllerAnimatedTransitioning {
    //返回动画的执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    //处理具体的动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresent ? presentAnimation(transitionContext) : dismissAnimation(transitionContext)
    }
}

//MARK: 弹出和消失动画的封装
extension PhotoBrowseAnimation {
    /// 弹出动画
    func presentAnimation( _ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentD = presentDelegate, let indexPath = indexPath else { return }
            
        //1.取出弹出的view
        guard let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        // 2.将弹出的View,添加到containerView中
        transitionContext.containerView.addSubview(presentView)
        
        //3.获取弹出的imageView
        let tempImageV = presentD.imageForPresent(indexPath: indexPath)
        tempImageV.frame = presentD.startImageRectForpresent(indexPath: indexPath)
        //containerView: 转场动画发生在该View中
        transitionContext.containerView.addSubview(tempImageV)
        transitionContext.containerView.backgroundColor = UIColor.black
        
        //4.执行动画
        presentView.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            tempImageV.frame = presentD.endImageRectForpresent(indexPath: indexPath)
        }) { (_) in
            transitionContext.containerView.backgroundColor = UIColor.clear
            //上报动画执行完毕
            transitionContext.completeTransition(true)
            tempImageV.removeFromSuperview()
            presentView.alpha = 1
        }
    }
    
    /// 消失动画
    func dismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentD = presentDelegate, let dismissD = dismissDelegate else { return }
        
        //1.取出消失的view
        guard let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        dismissView.alpha = 0
        
        //2.获取退出的imageView
        let tempImageV = dismissD.imageViewForDismiss()
        transitionContext.containerView.addSubview(tempImageV)
        
        //3.获取退出的indexpath
        let indexPath = dismissD.indexPathForDismiss()
        
        //4.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            tempImageV.frame = presentD.startImageRectForpresent(indexPath: indexPath)
        }) { (_) in
            tempImageV.removeFromSuperview()
            dismissView.removeFromSuperview()
            //上报动画执行完毕
            transitionContext.completeTransition(true)
        }
    }
}
