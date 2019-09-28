//
//  FlickerImageCell.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import UIKit

class FlickerImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: CachedImageView!
    
    var imageUrlString: String? {
        didSet {
            if let urlString = imageUrlString, let imageUrl = URL(string: urlString) {
                self.imageView.loadImageWithUrl(imageUrl)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
