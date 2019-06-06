//
//  NNest.swift
//  Nests
//
//  Created by liang on 2018/11/26.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation

public struct NNest<Base> {
    public let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol NNestExtentionProvider {
    associatedtype Nest
    var nest: Nest { get }
}

extension NNestExtentionProvider {
    public var nest: NNest<Self> {
        return NNest(self)
    }
}
