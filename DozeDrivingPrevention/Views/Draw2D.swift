//
//  DetectionView.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/4/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import UIKit

class Draw2D: UIView {
    
    func drawFaceRectangle(facialFeatures: FacialFeatures) {
        
        self.layer.sublayers = nil
        
        // Draw face
        let shapeView = CAShapeLayer()
        shapeView.fillColor = UIColor.clearColor().CGColor
        shapeView.strokeColor = UIColor.blueColor().CGColor
        shapeView.lineWidth = 2.0
        let faceRect = facialFeatures.face.featureRect
        let faceRectPath = UIBezierPath(roundedRect: faceRect, cornerRadius: 8.0)
        shapeView.path = faceRectPath.CGPath
        self.layer.addSublayer(shapeView)
        // Draw eye1
        let eye1shapeView = CAShapeLayer()
        eye1shapeView.fillColor = UIColor.clearColor().CGColor
        eye1shapeView.strokeColor = UIColor.cyanColor().CGColor
        eye1shapeView.lineWidth = 2.0
        let eye1Rect = facialFeatures.eye1.featureRect
        let eye1RectPath = UIBezierPath(roundedRect: eye1Rect, cornerRadius: 4.0)
        eye1shapeView.path = eye1RectPath.CGPath
        self.layer.addSublayer(eye1shapeView)
        // Draw eye2
        let eye2shapeView = CAShapeLayer()
        eye2shapeView.fillColor = UIColor.clearColor().CGColor
        eye2shapeView.strokeColor = UIColor.cyanColor().CGColor
        eye2shapeView.lineWidth = 2.0
        let eye2Rect = facialFeatures.eye2.featureRect
        let eye2RectPath = UIBezierPath(roundedRect: eye2Rect, cornerRadius: 4.0)
        eye2shapeView.path = eye2RectPath.CGPath
        self.layer.addSublayer(eye2shapeView)
        
    }
}
