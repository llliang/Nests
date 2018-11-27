//
//  NRefreshProtocol.swift
//  Nests
//
//  Created by liang on 2018/11/26.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation

/// refresh view state
///
/// - normal: 普通状态
/// - pullToRefresh: 下拉未达到刷新条件
/// - releaseToRefresh: 已达到刷新条件 释放即可刷新
/// - refreshing: 刷新中
public enum NRefreshState {
    case normal
    case pullToRefresh
    case releaseToRefresh
    case refreshing
}

public protocol NRefreshProtocol {
    
    /// 作用的view
    var view: UIView { get }
    
    /// 阀值 当offset到这个值时释放可以刷新
    var thresholdValue: CGFloat { set get }
    
    /// 动画view 与 base view 布局的间隔
    var insets: UIEdgeInsets { set get }
    
    /// 状态
    var state: NRefreshState { set get }
    
    /// 动画开始
    ///
    /// - Parameter refreshView: refreshView
    mutating func animationBegin(refreshView: NRefreshView)
    
    /// 动画结束
    ///
    /// - Parameter refreshView: refreshView
    mutating func animationEnd(refreshView: NRefreshView)
    
    /// 状态改变回调
    ///
    /// - Parameters:
    ///   - view: 作用的view
    ///   - stateDidChanged: 当前状态，NRefreshState
    mutating func refresh(view: NRefreshView, stateDidChanged: NRefreshState)
    
    /// refresh view 到达刷新的阀值前的进度
    ///
    /// - Parameters:
    ///   - view: 作用的view
    ///   - progress: 当前进度
    mutating func refresh(view: NRefreshView, progressDidChange progress: CGFloat)
}

/// 系统触感反馈器
fileprivate class NNestImpactor {
    
    static private var impactor: AnyObject? = {
        if #available(iOS 10.0, *) {
            if NSClassFromString("UIFeedbackGenerator") != nil {
                let generator = UIImpactFeedbackGenerator.init(style: .light)
                generator.prepare()
                return generator
            }
        }
        return nil
    }()
    
    static public func impact() -> Void {
        if #available(iOS 10.0, *) {
            if let impactor = impactor as? UIImpactFeedbackGenerator {
                impactor.impactOccurred()
            }
        }
    }
}

protocol NNestImpactorProtocol {
}

extension NNestImpactorProtocol {
    func impact() -> Void {
        NNestImpactor.impact()
    }
}
