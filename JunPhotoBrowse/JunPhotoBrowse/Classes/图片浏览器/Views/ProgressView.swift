//
//  ProgressView.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/25.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var progress: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //1. 获取参数
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let midR = min(rect.width, rect.height) / 2 - 6
        let start = CGFloat(Double.pi / 2)
        let end = start + progress * 2 * CGFloat(Double.pi)
        
        /*2.根据进度画出中间的圆
         参数：
         1. 中心点
         2. 半径
         3. 起始弧度
         4. 截至弧度
         5. 是否顺时针
         */
        let path = UIBezierPath(arcCenter: center, radius: midR, startAngle: start, endAngle: end, clockwise: true)
        path.addLine(to: center)
        path.close()
        UIColor(white: 1, alpha: 0.5).setFill()
        path.fill()
        
        //3.画出边线
        let rEdge = min(rect.width, rect.height) / 2 - 2
        let endEdge = start + 2 * CGFloat(Double.pi)
        let pathEdge = UIBezierPath(arcCenter: center, radius: rEdge, startAngle: start, endAngle: endEdge, clockwise: true)
        UIColor(white: 1, alpha: 0.5).setStroke()
        //绘制线根据坐标点连线
        pathEdge.stroke()
    }
}
