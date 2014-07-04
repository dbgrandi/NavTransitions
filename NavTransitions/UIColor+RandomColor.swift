//
//  UIColor+RandomColor.swift
//  NavTransitions
//
//  Created by David Grandinetti on 6/15/14.
//  Copyright (c) 2014 David Grandinetti. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func randomColor() -> UIColor {
        let hue = CGFloat( Float(arc4random() % 256) / 256)               // 0.0 to 1.0
        let saturation = CGFloat( Float(arc4random() % 128) / 256 ) + 0.5 //  0.5 to 1.0, away from white
        let brightness = CGFloat( Float(arc4random() % 128) / 256 ) + 0.5 //  0.5 to 1.0, away from black)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

