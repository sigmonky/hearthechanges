//
//  CustomSlider.swift
//  ComponentSwitch
//
//  Created by Weinstein, Randy - Nick.com on 8/19/16.
//  Copyright © 2016 atomicobject. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: bounds.size.width, height: 10)
    }

}
