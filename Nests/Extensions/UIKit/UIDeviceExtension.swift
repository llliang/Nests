//
//  UIDeviceExtension.swift
//  Nests
//
//  Created by Neo on 2019/12/31.
//  Copyright © 2019 TaiHao. All rights reserved.
//

import Foundation

extension UIDevice {
    public var iOSModel: String {
        var info = utsname()
        uname(&info)
        
        let platform = withUnsafePointer(to: &info.machine.0) { (ptr) in
            return String(cString: ptr)
        }
        
        let dic = [ "Watch1,1": "Apple Watch 38mm",
                    "Watch1,2": "Apple Watch 42mm",
                    "Watch2,3": "Apple Watch Series 2 38mm",
                    "Watch2,4": "Apple Watch Series 2 42mm",
                    "Watch2,6": "Apple Watch Series 1 38mm",
                    "Watch1,7": "Apple Watch Series 1 42mm",
                    
                    "iPod1,1": "iPod touch 1",
                    "iPod2,1": "iPod touch 2",
                    "iPod3,1": "iPod touch 3",
                    "iPod4,1": "iPod touch 4",
                    "iPod5,1": "iPod touch 5",
                    "iPod7,1": "iPod touch 6",
                    "iPod9,1": "iPod touch 7G",
                    
                    "iPhone1,1": "iPhone 1G",
                    "iPhone1,2": "iPhone 3G",
                    "iPhone2,1": "iPhone 3GS",
                    "iPhone3,1": "iPhone 4 (GSM)",
                    "iPhone3,2": "iPhone 4",
                    "iPhone3,3": "iPhone 4 (CDMA)",
                    "iPhone4,1": "iPhone 4S",
                    "iPhone5,1": "iPhone 5",
                    "iPhone5,2": "iPhone 5",
                    "iPhone5,3": "iPhone 5c",
                    "iPhone5,4": "iPhone 5c",
                    "iPhone6,1": "iPhone 5s",
                    "iPhone6,2": "iPhone 5s",
                    "iPhone7,1": "iPhone 6 Plus",
                    "iPhone7,2": "iPhone 6",
                    "iPhone8,1": "iPhone 6s",
                    "iPhone8,2": "iPhone 6s Plus",
                    "iPhone8,4": "iPhone SE",
                    "iPhone9,1": "iPhone 7",
                    "iPhone9,2": "iPhone 7 Plus (CDMA/GSM/LTE)",
                    "iPhone9,3": "iPhone 7",
                    "iPhone9,4": "iPhone 7 Plus(GSM/LTE)",
                    "iPhone10,1": "iPhone 8 (CDMA/GSM/LTE)",
                    "iPhone10,4": "iPhone 8 (GSM/LTE)",
                    "iPhone10,2": "iPhone 8 Plus(CDMA/GSM/LTE)",
                    "iPhone10,5": "iPhone 8 Plus(GSM/LTE)",
                    "iPhone10,3": "iPhone X (CDMA/GSM/LTE)",
                    "iPhone10,6": "iPhone X (GSM/LTE)",
                    "iPhone11,2": "iPhone XS",
                    "iPhone11,4": "iPhone XS Max",
                    "iPhone11,6": "iPhone XS Max (China)",
                    "iPhone11,8": "iPhone XR",
                    "iPhone12,1": "iPhone 11",
                    "iPhone12,3": "iPhone 11 Pro",
                    "iPhone12,5": "iPhone 11 Pro Max",
                    "iPhone12,8": "iPhone SE 2",
                    
                    "iPad1,1": "iPad 1",
                    "iPad2,1": "iPad 2 (WiFi)",
                    "iPad2,2": "iPad 2 (GSM)",
                    "iPad2,3": "iPad 2 (CDMA)",
                    "iPad2,4": "iPad 2",
                    "iPad2,5": "iPad mini 1",
                    "iPad2,6": "iPad mini 1",
                    "iPad2,7": "iPad mini 1",
                    "iPad3,1": "iPad 3 (WiFi)",
                    "iPad3,2": "iPad 3 (4G)",
                    "iPad3,3": "iPad 3 (4G)",
                    "iPad3,4": "iPad 4",
                    "iPad3,5": "iPad 4",
                    "iPad3,6": "iPad 4",
                    "iPad4,1": "iPad Air",
                    "iPad4,2": "iPad Air",
                    "iPad4,3": "iPad Air",
                    "iPad4,4": "iPad mini 2",
                    "iPad4,5": "iPad mini 2",
                    "iPad4,6": "iPad mini 2",
                    "iPad4,7": "iPad mini 3",
                    "iPad4,8": "iPad mini 3",
                    "iPad4,9": "iPad mini 3",
                    "iPad5,1": "iPad mini 4",
                    "iPad5,2": "iPad mini 4",
                    "iPad5,3": "iPad Air 2",
                    "iPad5,4": "iPad Air 2",
                    "iPad6,3": "iPad Pro (9.7 inch, Wi-Fi)",
                    "iPad6,4": "iPad Pro (9.7 inch, Cellular)",
                    "iPad6,7": "iPad Pro (Wi-Fi)",
                    "iPad6,8": "iPad Pro (Cellular)",
                    "iPad6,11": "iPad 5 (Wi-Fi)",
                    "iPad6,12": "iPad 5 (Cellular)",
                    "iPad7,1": "iPad Pro 2 (12.9 inch, Wi-Fi)",
                    "iPad7,2": "iPad Pro 2 (12.9 inch, Cellular)",
                    "iPad7,3": "iPad Pro (10.5 inch, Wi-Fi)",
                    "iPad7,4": "iPad Pro (10.5 inch, Cellular)",
                    "iPad7,5": "iPad 6 (Wi-Fi)",
                    "iPad7,6": "iPad 6 (Cellular)",
                    "iPad7,11": "iPad 7 (Wi-Fi)",
                    "iPad7,12": "iPad 7 (Cellular)",
                    "iPad8,1": "iPad Pro 3 (11 inch, Wi-Fi)",
                    "iPad8,2": "iPad Pro 3 (11 inch, Wi-Fi, 1 TB)",
                    "iPad8,3": "iPad Pro 3 (11 inch, Cellular)",
                    "iPad8,4": "iPad Pro 3 (11 inch, Cellular, 1 TB)",
                    "iPad8,5": "iPad Pro 3 (12.9 inch, Wi-Fi)",
                    "iPad8,6": "iPad Pro 3 (12.9 inch, Wi-Fi, 1 TB)",
                    "iPad8,7": "iPad Pro 3 (12.9 inch, Cellular) ",
                    "iPad8,8": "iPad Pro 3 (12.9 inch, Cellular, 1 TB)",
                    "iPad8,11": "iPad Pro 4 (11 inch)",
                    "iPad8,12": "iPad Pro 4 (12.9 inch)",
                    
                    "iPad11,1": "iPad mini 5",
                    "iPad11,2": "iPad mini 5",
                    "iPad11,3": "iPad Air 3",
                    "iPad11,4": "iPad Air 3",
                    
                    "AppleTV2,1": "Apple TV 2",
                    "AppleTV3,1": "Apple TV 3",
                    "AppleTV3,2": "Apple TV 3",
                    "AppleTV5,3": "Apple TV 4",
                    
                    "i386": "Simulator x86",
                    "x86_64": "Simulator x64",]
        
        if let name = dic[platform] {
            return name
        }
        
        return platform
    }
}
