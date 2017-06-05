//
//  Utilities.swift
//  InstaClone
//
//  Created by Relorie on 6/6/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import UIKit


class Utilities {

    class func configureTextFieldAppearence(for textField: UITextField){
        textField.backgroundColor = UIColor.clear
        textField.tintColor = UIColor.white
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor(white :1.0, alpha: 0.6)])
        let bottomLayer: CALayer = CALayer()
        bottomLayer.frame = CGRect(x:0 ,y:29, width:1000, height: 5)
        bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLayer)
    
    }
}
