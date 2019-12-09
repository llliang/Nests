//
//  UIViewFrameExtension.swift
//  Nests
//
//  Created by liang on 2018/11/28.
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
