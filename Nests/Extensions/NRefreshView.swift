//
//  NRefreshView.swift
//  Nests
//
//  Created by liang on 2018/11/26.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation

public typealias NRefreshHandler = (() -> Void)

open class NRefreshView: UIView {
   
    /// 触发器的弱引用
    open weak var scrollView: UIScrollView?
    
    /// 刷新的回调
    public var refreshHandler: NRefreshHandler?
    
    /// 动画构造器
    public var animator: NRefreshProtocol!
    
    /// 是否添加观察者
    var isObserving: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(frame: CGRect, refreshViewAnimator animator: NRefreshProtocol = NRefreshViewAnimator(), refreshHandler handler: @escaping NRefreshHandler) {
        self.init(frame: frame)
        self.animator = animator
        self.refreshHandler = handler
    }
    
    deinit {
        self.removeObserver()
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObserver()
        DispatchQueue.main.async {
            [weak self] in
            self?.addObserver(newSuperview)
        }
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.scrollView = self.superview as? UIScrollView
        
        if self.subviews.contains(animator.view) {
            
        }
    }
    
}

// MARK: - KVO
extension NRefreshView {
    
    func removeObserver() {
        
    }
    func addObserver(_ toView: UIView?) {
        
    }
}

open class NRefreshHeaderView: NRefreshView {
    
}

open class NRefreshFooterView: NRefreshView {
    
}


