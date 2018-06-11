//
//  ImageCollectionViewCell.swift
//  ZDT_InstaTutorial
//
//  Created by Sztanyi Szabolcs on 22/12/15.
//  Copyright © 2015 Zappdesigntemplates. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
