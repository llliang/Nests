//
//  UIScorllViewExtention.swift
//  Nests
//
//  Created by liang on 2018/11/26.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation

extension UIScrollView: NNestExtentionProvider {
    
}

private var kRefreshHeaderKey: Void?
private var kRefreshFooterKey: Void?
///  header/footer
extension UIScrollView {
    
    public var headerView: NRefreshHeaderView? {
        set {
            objc_setAssociatedObject(self, &kRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &kRefreshHeaderKey) as? NRefreshHeaderView
        }
    }
    
    public var footerView: NRefreshFooterView? {
        set {
            objc_setAssociatedObject(self, &kRefreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &kRefreshFooterKey) as? NRefreshFooterView
        }
    }
}

extension NNest where Base: UIScrollView {
    
    @discardableResult public func add(refreshHeaderAnimator animator: NRefreshProtocol = NRefreshViewAnimator(), refreshHeaderHandler handler: @escaping NRefreshHandler) -> NRefreshHeaderView {
        let rect = CGRect(x: 0, y: 0, width: -animator.thresholdValue - self.base.contentInset.top, height: animator.thresholdValue)
        let header = NRefreshHeaderView(frame: rect, refreshViewAnimator: animator, refreshHandler: handler)
        self.base.addSubview(header)

        self.base.headerView = header
        return header
    }
    
    @discardableResult public func add(refreshFooterAnimator animator: NRefreshProtocol = NRefreshViewAnimator(), refreshFooterHandler handler: @escaping NRefreshHandler) -> NRefreshFooterView {
        let rect = CGRect(x: 0, y: self.base.contentSize.height + self.base.contentInset.bottom, width: -animator.thresholdValue, height: animator.thresholdValue)
        let footer = NRefreshFooterView(frame: rect, refreshViewAnimator: animator, refreshHandler: handler)
        self.base.addSubview(footer)
        self.base.footerView = footer
        return footer
    }
    
    public func startToRefresh() {
        guard let headerView = self.base.headerView, !headerView.isRefreshing else {
            return
        }
        self.base.headerView?.startRefreshing()
        
        
    }
    
    public func stopToRefresh() {
        
    }
    
    public func startToLoadMore() {
        
    }
    
    public func stopToLoadMore() {
        
    }
    
}
