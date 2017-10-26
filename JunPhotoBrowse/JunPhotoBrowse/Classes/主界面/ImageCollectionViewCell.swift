//
//  ImageCollectionViewCell.swift
//  JunPhotoBrowse
//
//  Created by iOS_Tian on 2017/10/24.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    var imageModel: ImageModel? {
        didSet{
            guard let model = imageModel else { return }
            
            imageView.kf.setImage(with: URL(string: model.pic74))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
