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
    func customActivityIndicator(view: UIView, widthView: CGFloat? = nil, backgroundColor: UIColor? = nil, message: String? = nil,colorMessage:UIColor? = nil ) -> UIView{
        
        //Config UIView
        self.backgroundColor = backgroundColor ?? UIColor.clear
        self.layer.cornerRadius = 10
        
        
        var selfWidth = view.frame.width - 100
        if widthView != nil{
            selfWidth = widthView ?? selfWidth
        }
        
        let selfHeigh = CGFloat(100)
        let selfFrameX = (view.frame.width / 2) - (selfWidth / 2)
        let selfFrameY = (view.frame.height / 2) - (selfHeigh / 2)
        let rotateImage = UIImageView(image: #imageLiteral(resourceName: "Swerve Logo"))
        
        //ConfigCustomLoading with secuence images
        rotateImage.rotate(imageView: rotateImage)
//        let imageListArray = [#imageLiteral(resourceName: "Swerve Logo"), #imageLiteral(resourceName: "Swerve Logo Caption")]
//        loopImages.animationImages = imageListArray
//        loopImages.animationDuration = TimeInterval(1.3)
//        loopImages.startAnimating()
        let imageFrameX = (selfWidth / 2) - 17
        let imageFrameY = (selfHeigh / 2) - 35
        var imageWidth = CGFloat(35)
        var imageHeight = CGFloat(35)
        
        if widthView != nil{
            imageWidth = widthView ?? imageWidth
            imageHeight = widthView ?? imageHeight
        }
        
        //ConfigureLabel
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.text = message ?? ""
        label.textColor = colorMessage ?? UIColor.clear
        
        //Config frame of label
        let labelFrameX = (selfWidth / 2) - 100
        let labelFrameY = (selfHeigh / 2) - 10
        let labelWidth = CGFloat(200)
        let labelHeight = CGFloat(70)
        
        //add loading and label to customView
        //self.addSubview(loopImages)
        self.addSubview(rotateImage)
        self.addSubview(label)
        
        //Define frames
        //UIViewFrame
        self.frame = CGRect(x: selfFrameX, y: selfFrameY, width: selfWidth , height: selfHeigh)
        
        //ImageFrame
        //loopImages.frame = CGRect(x: imageFrameX, y: imageFrameY, width: imageWidth, height: imageHeight)
        rotateImage.frame = CGRect(x: imageFrameX, y: imageFrameY, width: imageWidth, height: imageHeight)
        
        //LabelFrame
        label.frame = CGRect(x: labelFrameX, y: labelFrameY, width: labelWidth, height: labelHeight)
        
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
