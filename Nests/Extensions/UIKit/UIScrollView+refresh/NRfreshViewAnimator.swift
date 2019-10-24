//
//  NRfreshViewAnimator.swift
//  Nests
//
//  Created by liang on 2018/11/26.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation

/// 默认 animator
open class NRefreshViewAnimator: NRefreshProtocol {
    
    public init() {}
    
    public var view: UIView = UIView()
    
    public var thresholdValue: CGFloat = 60.0
    
    public var insets: UIEdgeInsets = .zero
    
    public var state: NRefreshState = .pullToRefresh
    
    public func animationBegin(refreshView: NRefreshView) {
        
    }
    
    public func animationEnd(refreshView: NRefreshView) {
        
    }
    
    public func refresh(view: NRefreshView, stateDidChanged: NRefreshState) {
        
    }
    
    public func refresh(view: NRefreshView, progressDidChange progress: CGFloat) {
        
    }
    
    
}

