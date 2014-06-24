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

    // Brightness math based on:
    // http://www.nbdtech.com/Blog/archive/2008/04/27/Calculating-the-Perceived-Brightness-of-a-Color.aspx
    // Based on gist: https://gist.github.com/jlong/f06f5843104ee10006fe
    //
    func brightness() -> Float {
        let redMagicNumber: CGFloat    = 241
        let greenMagicNumber: CGFloat  = 691
        let blueMagicNumber: CGFloat   = 68
        let brightnessDivisor: CGFloat = redMagicNumber + greenMagicNumber + blueMagicNumber
        
        // Extract color components
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
       
        red = red*255
        green = green*255
        blue = blue*255

        // Calculate a brightness value in 3d color space between 0 and 255
        let red3d = red * red * redMagicNumber
        let green3d = green * green * greenMagicNumber
        let blue3d = blue * blue * blueMagicNumber

        let composite: CGFloat = red3d + green3d + blue3d
        let div = Float(Float(composite) / Float(brightnessDivisor))
        let num = sqrtf( CGFloat(div) )
        
        // Convert to percentage and return
        return num / 255
    }
    
    func contrastingTextColor() -> UIColor {
        return contrastingColor(UIColor.whiteColor(), dark: UIColor.blackColor())
    }
    
    func contrastingColor(light: UIColor, dark: UIColor) -> UIColor {
        if brightness() < 0.65 {
//            println("contrastingColor == light")
            return light
        } else {
//            println("contrastingColor == dark")
            return dark
        }
    }
}

