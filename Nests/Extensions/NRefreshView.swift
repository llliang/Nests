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
    
    fileprivate var _isRefreshing = false
    
    open var isRefreshing: Bool {
        return _isRefreshing
    }
    
    /// 是否添加观察者
    var isObserving: Bool = false
    var isIgnoreObserver = false
    
    fileprivate var scrollViewContentInsents: UIEdgeInsets = UIEdgeInsets.zero
//    fileprivate var
    
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
    
    public final func startRefreshing() {
        if _isRefreshing {
            return
        }
        self.start()
    }
    
    public final func stopRefreshing() {
        if !_isRefreshing {
            return
        }
        self.stop()
    }
    
    public func start() {
        _isRefreshing = true

    }
    
    public func stop() {
        _isRefreshing = false
    }
    
    /// 对应的scroll view size changed 参考重新布局
    ///
    /// - Parameters:
    ///   - object: Any?
    ///   - change: [NSKeyValueChange: Any]?
    open func didChangeContentSize(object: Any?, change: [NSKeyValueChangeKey: Any]?) {
      
    }
    
    /// 对应的scroll view offset changed
    ///
    /// - Parameters:
    ///   - object: Any?
    ///   - change: [NSKeyValueChange: Any]?
    open func didChangeContentOffset(object: Any?, change: [NSKeyValueChangeKey: Any]?) {
        
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
        
        if !self.subviews.contains(animator.view) {
            let insets = animator.insets;
            animator.view.frame = CGRect(x: insets.left, y: insets.top, width: self.width - insets.left - insets.right, height: self.height - insets.top - insets.bottom)
            self.addSubview(animator.view)
            animator.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
}

// MARK: - KVO 监测 scroll view
extension NRefreshView {
    
    /// 本地化变量
    fileprivate static let contentOffset = "contentOffset"
    fileprivate static let contentSize = "contentSize"
    fileprivate static var refreshContext = "ObserverContext"
    
    /// 添加KVO
    ///
    /// - Parameter toView: scroll view
    func addObserver(_ toView: UIView?) {
        if let scrollView = toView as? UIScrollView,false == isObserving {
            scrollView.addObserver(self, forKeyPath: NRefreshView.contentOffset, options: [.initial, .new], context: &NRefreshView.refreshContext)
            scrollView.addObserver(self, forKeyPath: NRefreshView.contentSize, options: [.initial, .new], context: &NRefreshView.refreshContext)
            
            isObserving = true
        }
    }
    
    /// 移除 KVO
    func removeObserver() {
        if let scrollView = superview as? UIScrollView, isObserving {
            scrollView.removeObserver(self, forKeyPath: NRefreshView.contentOffset)
            scrollView.removeObserver(self, forKeyPath: NRefreshView.contentSize)
            
            isObserving = false
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &NRefreshView.refreshContext else {
            return
        }
        
        if context == &NRefreshView.refreshContext {
            
            if keyPath == NRefreshView.contentSize, true != isIgnoreObserver {
                didChangeContentSize(object: object, change: change)
            } else if keyPath == NRefreshView.contentOffset, true != isIgnoreObserver {
                didChangeContentOffset(object: object, change: change)
            }
        }
    }
}

open class NRefreshHeaderView: NRefreshView {

    override open func didChangeContentOffset(object: Any?, change: [NSKeyValueChangeKey : Any]?) {
 
        guard let scrollView = scrollView else {
            return
        }
        super.didChangeContentOffset(object: object, change: change)
        
        guard _isRefreshing == false else {
            let top = scrollViewContentInsents.top
            let offsetY = scrollView.contentOffset.y
            let height = self.frame.size.height
            var scrollingTop = (-offsetY > top) ? -offsetY : top
            scrollingTop = (scrollingTop > height + top) ? (height + top) : scrollingTop
            
            scrollView.contentInset.top = scrollingTop
            return
        }
        
        self.animator.refresh(view: self, progressDidChange: 0)
     
        let offsetY = scrollView.contentOffset.y
        print("offsetY = \(offsetY)")
        
    }
    
    open override func start() {
        guard let scrollView = scrollView else {
            return
        }
        self.scrollViewContentInsents = scrollView.contentInset
        
    }
}

open class NRefreshFooterView: NRefreshView {
    
    override open func didChangeContentSize(object: Any?, change: [NSKeyValueChangeKey : Any]?) {
        super.didChangeContentSize(object: object, change: change)
        if let scrollView = scrollView {
            self.isHidden = scrollView.contentSize.height < scrollView.height
        }
        if self.isRefreshing {
            
        }
    }
    
    override open func didChangeContentOffset(object: Any?, change: [NSKeyValueChangeKey : Any]?) {
        
        guard let scrollView = scrollView else {
            return
        }
        super.didChangeContentOffset(object: object, change: change)
        
        
    }
    
}


