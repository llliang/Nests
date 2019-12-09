//
//  UIViewFrameExtension.swift
//  Nests
//
//  Created by Neo on 2018/11/28.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation

// MARK: - frame extension
extension UIView {
    
    /// origin.y
    public var top: CGFloat {
        set {
            self.frame = CGRect(x: self.frame.minX, y: newValue, width: self.frame.width, height: self.frame.height)
        }
        
        get {
            return self.frame.minY
        }
    }
    
    /// origin.x
    public var left: CGFloat {
        set {
            self.frame = CGRect(x: newValue, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
        }
        
        get {
            return self.frame.minX
        }
    }
    
    /// origin.y + height
    public var bottom: CGFloat {
        set {
            self.frame = CGRect(x: self.frame.minX, y: newValue - self.frame.height, width: self.frame.width, height: self.frame.height)
        }
        
        get {
            return self.frame.maxY
        }
    }
    
    /// origin.x + width
    public var right: CGFloat {
        set {
            self.frame = CGRect(x: newValue - self.frame.width, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
        }
        
        get {
            return self.frame.maxX
        }
    }
    
    /// width
    public var width: CGFloat {
        set {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: newValue, height: self.frame.height)
        }
        
        get {
            return self.frame.width
        }
    }
    
    /// height
    public var height: CGFloat {
        set {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: newValue)
        }
        
        get {
            return self.frame.height
        }
    }
}

public struct NCornerRadii {
    public var leftTop: CGFloat = 0
    public var rightTop: CGFloat = 0
    public var leftBottom: CGFloat = 0
    public var rightBottom: CGFloat = 0
    
    
    public init(radius: CGFloat) {
        leftTop = radius
        rightTop = radius
        leftBottom = radius
        rightBottom = radius
    }
    
    public init(leftTop: CGFloat, rightTop: CGFloat, leftBottom: CGFloat, rightBottom: CGFloat) {
        self.leftTop = leftTop
        self.rightTop = rightTop
        self.leftBottom = leftBottom
        self.rightBottom = rightBottom
    }
}

extension UIView {
    
    /// 在设置完frame后 给view添加圆角
    /// - Parameter corners: 需要添加的圆角位置
    /// - Parameter cornerRadii: 圆角的大小 宽/高 不能大于view的宽高
    public func add(corners: UIRectCorner, cornerRadii: CGSize) {
//        if self.height/2 < cornerRadii.height || self.width/2 < cornerRadii.width {
//            return
//        }
//
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let shaper = CAShapeLayer()
        shaper.path = path.cgPath
        self.layer.mask = shaper
    }
    
    public func addCornerRadius(radii: NCornerRadii) {
        let path = CGMutablePath()
        
        let pi = CGFloat.pi
        
        // leftTop
        let leftTopCenter = CGPoint(x: radii.leftTop, y: radii.leftTop)
        path.addArc(center: leftTopCenter, radius: radii.leftTop, startAngle: pi, endAngle: 1.5 * pi, clockwise: false)
        
        let rightTopCenter = CGPoint(x: self.width - radii.rightTop, y: radii.rightTop)
        path.addArc(center: rightTopCenter, radius: radii.rightTop, startAngle: 1.5 * pi, endAngle: 0, clockwise: false)
        
        let rightBottomCenter = CGPoint(x: self.width - radii.rightBottom, y: self.height - radii.rightBottom)
        path.addArc(center: rightBottomCenter, radius: radii.rightBottom, startAngle: 0, endAngle: 0.5 * pi, clockwise: false)
        let leftBottomCenter = CGPoint(x: radii.leftBottom, y: self.height - radii.leftBottom)
        path.addArc(center: leftBottomCenter, radius: radii.leftBottom, startAngle: 0.5 * pi, endAngle: pi, clockwise: false)
        
        
        path.closeSubpath()
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = path
        self.layer.mask = shadowLayer
    }
}
