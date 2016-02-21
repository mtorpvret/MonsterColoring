//
//  ColorViewController.swift
//  MonsterColoring
//
//  Created by Markus Torpvret on 2016-02-21.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, HSBColorPickerDelegate {
    
    @IBOutlet var colorPicker: HSBColorPicker!
    
    var pixelColor = Pixel(value: 0)
    var context: DrawingContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPicker.delegate = self
        let tbc = tabBarController as! DrawingTabBarController
        context = tbc.context
        print("In: Drawing color: \(context!.color)")

    }
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        var r = CGFloat()
        var g = CGFloat()
        var b = CGFloat()
        var a = CGFloat()
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            print ("Color: \(r), \(g), \(b), (\(a))")
            let red = UInt32(r*255)
            let green = UInt32(g*255)
            let blue = UInt32(b*255)
            let alpha = UInt32(a*255)
            pixelColor = Pixel(value: alpha << 24 + blue << 16 + green << 8 + red)
            context!.color = pixelColor
        }
    }
}


