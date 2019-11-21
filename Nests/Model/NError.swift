//
//  NError.swift
//  Nests
//
//  Created by Neo on 2019/11/14.
//  Copyright © 2019 TaiHao. All rights reserved.
//

import Foundation

public struct NError: LocalizedError {
    
    public var errorCode: Int
    
    var errorReason: String?
    
    public init(reason: String?, code: Int = -10000) {
        errorReason = reason
        errorCode = code
    }
    
    var localizedDescription: String? {
        return errorReason
    }
    
    public var errorDescription: String? {
        return errorReason
    }
}
