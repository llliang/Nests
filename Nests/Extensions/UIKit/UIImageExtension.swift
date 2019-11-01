//
//  UIImageExtension.swift
//  Nests
//
//  Created by Neo on 2019/10/29.
//  Copyright © 2019 TaiHao. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 用纯颜色生产相应图片
    /// - Parameter withColor: 生成的颜色
    /// - Parameter size: 图片的大小， 默认为1像素宽/高
    public static func image(withColor: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(withColor.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
