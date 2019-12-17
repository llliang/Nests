//
//  StringExtension.swift
//  Nests
//
//  Created by Neo on 2019/12/16.
//  Copyright © 2019 TaiHao. All rights reserved.
//

import Foundation

extension String {
    
    public func subString(from: UInt, to: UInt) -> String? {
        if from >= self.count {
            return nil
        }
        
        if from >= to {
            return nil
        }
        
        var end: Int = Int(to)
        if to > self.count {
            end = self.count
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: Int(from))
        let endIndex = self.index(self.startIndex, offsetBy: end)
        return String(self[startIndex..<endIndex])
    }
    
    public func ranges(ofString: String) -> [Range<String.Index>]? {
        if ofString.isEmpty || self.isEmpty {
            return nil
        }
        
        guard let sr = range(of: self) else {
            return nil
        }
        
        var ranges = [Range<String.Index>]()
        var searchRange = sr
      
        while let range = range(of: ofString, options: .regularExpression, range: searchRange, locale: nil) {
            ranges.append(range)
            searchRange = Range(uncheckedBounds: (range.upperBound, self.endIndex))
        }
        
        return ranges
    }
}
