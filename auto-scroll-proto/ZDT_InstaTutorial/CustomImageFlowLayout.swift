//
//  CustomImageFlowLayout.swift
//  ZDT_InstaTutorial
//
//  Created by Sztanyi Szabolcs on 22/12/15.
//  Copyright © 2015 Zappdesigntemplates. All rights reserved.
//

import UIKit

class CustomImageFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 3
           
            let itemWidth = 200.0
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }

    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }

}
