//
//  JunTransitionView.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/26.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

protocol JuntransitionDelegate {
    func tranisitionAnimationType(type: String)
}

class JunTransitionView: UIView {

    //定义闭包反向传值
    var delegate: JuntransitionDelegate?
    fileprivate var whiteView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        
        creatAnimations()
        
    }
    
    fileprivate func creatAnimations(){
        whiteView = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight / 3))
        whiteView.backgroundColor = UIColor.white
        addSubview(whiteView)
        
        //创建按钮
        let titles = [["fade", "moveIn"], ["push", "reveal"], ["cube", "oglFlip"], ["pageCurl", "pageUnCurl"]]
        
        for i in 0..<4 {
            for j in 0..<2 {
                let button = UIButton(title: titles[i][j], bgColor: UIColor.darkGray, fontSize: 15)
                button.frame = CGRect(x: (kScreenWidth/2 - 100) / 2 + kScreenWidth / 2 * CGFloat(j), y: (20 + 30) * CGFloat(i) + 20, width: 100, height: 30)
                button.addTarget(self, action: #selector(animationTypeAction(sender:)), for: .touchUpInside)
                whiteView.addSubview(button)
            }
        }
        
        //弹出视图
        UIView.animate(withDuration: 0.25) {
            self.whiteView.frame.origin.y = kScreenHeight / 3 * 2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: 视图消失
extension JunTransitionView {
    @objc fileprivate func animationTypeAction(sender: UIButton){
        var type = "cube"
        switch sender.currentTitle! {
        case "fade":
            type = kCATransitionFade
        case "moveIn":
            type = kCATransitionMoveIn
        case "push":
            type = kCATransitionPush
        case "reveal":
            type = kCATransitionReveal
        default:
            type = sender.currentTitle!
        }
        delegate?.tranisitionAnimationType(type: type)
        dismissTransitionView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissTransitionView()
    }
    
    fileprivate func dismissTransitionView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.whiteView.frame.origin.y = kScreenHeight
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
