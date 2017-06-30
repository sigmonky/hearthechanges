//
//  CheckBox.swift
//  ComponentSwitch
//
//  Created by Weinstein, Randy - Nick.com on 11/17/16.
//  Copyright © 2016 atomicobject. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

        // Images
        let checkedImage = UIImage(named: "ic_check_box")! as UIImage
        let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
        
        // Bool property
        var isChecked: Bool = false {
            didSet{
                if isChecked == true {
                    self.setImage(checkedImage, for: .normal)
                } else {
                    self.setImage(uncheckedImage, for: .normal)
                }
            }
        }
        
        override func awakeFromNib() {
            self.addTarget(self, action: "buttonClicked:", for: UIControlEvents.touchUpInside)
            self.isChecked = false
        }
        
        func buttonClicked(sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }
}


