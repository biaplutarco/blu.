//
//  Gradient.swift
//  THEAPP
//
//  Created by Ada 2018 on 15/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
        
        private var gradientLayer: CAGradientLayer!
        
        @IBInspectable var topColor: UIColor = .red {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var bottomColor: UIColor = .yellow {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var startPointX: CGFloat = 0 {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var startPointY: CGFloat = 0.5 {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var endPointX: CGFloat = 1 {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var endPointY: CGFloat = 0.5 {
            didSet {
                setNeedsLayout()
            }
        }
    
        override class var layerClass: AnyClass {
            return CAGradientLayer.self
        }
        
        override func layoutSubviews() {
            self.gradientLayer = self.layer as! CAGradientLayer
            self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
            self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
            self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        
        }

}
