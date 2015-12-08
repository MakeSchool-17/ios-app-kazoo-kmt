//
//  DetectionView.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/4/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import UIKit

class Draw2D: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        
        /*
        CGContextMoveToPoint(context, 30, 30)
        CGContextAddLineToPoint(context, 300, 400)
        */
        
        let rectangle = CGRectMake(60,170,200,80)

        CGContextAddRect(context, rectangle)
        CGContextStrokePath(context)
        
        
    }
}
