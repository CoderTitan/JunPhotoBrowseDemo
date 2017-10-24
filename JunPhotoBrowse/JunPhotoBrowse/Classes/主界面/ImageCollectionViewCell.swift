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
    @IBOutlet weak var imageView: UIImageView!
    
    var imageModel: ImageModel? {
        didSet{
            guard let model = imageModel else { return }
            
            imageView.kf.setImage(with: URL(string: model.pic74))
        }
    }
    
}
