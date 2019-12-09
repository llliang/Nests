//
//  DictionaryExtension.swift
//  Nests
//
//  Created by Neo on 2019/10/23.
//  Copyright © 2019 TaiHao. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// 将字典转化为json string
    public func toJsonString() -> String? {
        if !JSONSerialization.isValidJSONObject(self) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
