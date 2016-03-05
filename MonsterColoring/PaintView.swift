//
//  PaintView.swift
//  MonsterColoring
//
//  Created by Markus Torpvret on 2016-02-20.
//  Copyright © 2016 Markus Torpvret. All rights reserved.
//

import UIKit

class PaintView: UIImageView {
    private var _cImage = ColoringImage(size: CGSize(width: 100,height: 100))
    var context: PaintingContext?
    var cancelled = false
    
    var paintImage: UIImage? {
        get {
            return image
        }
        set(paintImage) {
            if let existingPaintImage = paintImage {
                if let newImage = ColoringImage(image: existingPaintImage) {
                    _cImage = newImage
                    _cImage.makeBWImage()
                    updateImage()
                }
            }
        }
    }
    
    func updateImage() {
        image = _cImage.toUIImage()
        
    }

    func outOfBounds(point: CGPoint, width: Int, height: Int) -> Bool {
        let oob = point.x > CGFloat(width) || point.y > CGFloat(height)
        print("Out of bounds for point \(point), width \(width), height \(height) = \(oob)")
        return oob
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancelled = false
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancelled = true
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if !cancelled {
            print("View bounds: \(self.bounds)")
            print("Imgage size: \(_cImage.width)x\(_cImage.height)")
            if touches.count > 1 { return }
            if let touch = touches.first {
                let pos = touch.locationInView(self)
                print("Point: \(pos)")
                if outOfBounds(pos, width: _cImage.width, height: _cImage.height) { return }
            
                let colorPixel = context!.color
                _cImage.fillWithColor(colorPixel, atPoint: pos)
                updateImage()
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        cancelled = true
        super.touchesCancelled(touches, withEvent: event)
    }
}