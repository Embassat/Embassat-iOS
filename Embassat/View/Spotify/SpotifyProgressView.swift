//
//  SpotifyProgressView.swift
//  Embassat
//
//  Created by Joan Romano on 28/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import Foundation

final class SpotifyProgressView: UIView {
    
    override class var layerClass: Swift.AnyClass { return CAShapeLayer.self }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shape = layer as! CAShapeLayer
        
        shape.fillColor = nil
        shape.strokeColor = UIColor.secondary.cgColor
        shape.lineWidth = 3
        shape.path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2),
                                  radius: frame.width/2 - 10,
                                  startAngle: CGFloat(-M_PI_2),
                                  endAngle: CGFloat(-M_PI_2 + (M_PI * 2)),
                                  clockwise: true).cgPath
        
    }
    
    /// Sets the current progress
    ///
    /// - Parameter progress: a progress between 0 and 1
    func setProgress(_ progress: CGFloat) {
        guard progress > 0 && progress < 1 else { return }
        
        (layer as! CAShapeLayer).strokeStart = progress
    }
}
