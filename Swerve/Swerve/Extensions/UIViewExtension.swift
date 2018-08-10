//
//  UIViewExtension.swift
//  Swerve
//
//  Created by Daniel Harris on 10/08/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func customActivityIndicator(view: UIView) -> UIView{
        
        //config rotating image
        let rotateImage = UIImageView(image: #imageLiteral(resourceName: "Swerve Logo"))

        rotateImage.rotate(imageView: rotateImage)
        
        let imageWidth = CGFloat(view.frame.width / 4)
        let imageHeight = CGFloat(view.frame.width / 4)
        let imageFrameX = view.center.x - imageWidth / 2
        let imageFrameY = view.center.y - imageHeight - 2
        
        //add loading customView
        self.addSubview(rotateImage)
        
        //ImageFrame
        rotateImage.frame = CGRect(x: imageFrameX, y: imageFrameY, width: imageWidth, height: imageHeight)
        
        return self
        
    }
    
}

extension UIImageView {
    func rotate(imageView: UIImageView) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(floatLiteral: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
}
