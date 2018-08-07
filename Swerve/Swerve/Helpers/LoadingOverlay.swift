//
//  LoadingOverlay.swift
//  Swerve
//
//  Created by Daniel Harris on 29/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

public class LoadingOverlay {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var swerveOverlayView = UIView()
    var swerveLabel = UILabel()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(_ view: UIView) {
        
        overlayView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: view.frame.width, height: view.frame.height))
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.7)
        overlayView.clipsToBounds = true
        
        activityIndicator.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 40, height: 40))
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = view.center
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        overlayView.bringSubview(toFront: overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
    
    public func showSwerveView(_ view: UIView) {
        swerveOverlayView.frame = CGRect(x: 0, y: 0, width: 3*view.frame.width/4, height: view.frame.height/2)
        swerveOverlayView.center = view.center
        swerveOverlayView.backgroundColor = UIColor.white
        swerveOverlayView.clipsToBounds = true
        swerveOverlayView.layer.cornerRadius = 10
        swerveOverlayView.layer.borderWidth = 1
        swerveOverlayView.layer.borderColor = UIColor.black.cgColor
        
        swerveLabel.text = "Swerve!"
        swerveLabel.textColor = UIColor(displayP3Red: 0.482, green: 0.502, blue: 0.478, alpha: 1)
        swerveLabel.sizeToFit()
        
        view.addSubview(swerveOverlayView)
        view.addSubview(swerveLabel)
        swerveLabel.center = swerveOverlayView.center
        view.bringSubview(toFront: swerveLabel)
    }
    
    public func hideSwerveView() {
        swerveOverlayView.removeFromSuperview()
        swerveLabel.removeFromSuperview()
    }
}
