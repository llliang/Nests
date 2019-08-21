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
    
    public var refreshHeader: NRefreshHeaderView? {
        set {
            objc_setAssociatedObject(self, &kRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &kRefreshHeaderKey) as? NRefreshHeaderView
        }
    }
    
    public var refreshFooter: NRefreshFooterView? {
        set {
            objc_setAssociatedObject(self, &kRefreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &kRefreshFooterKey) as? NRefreshFooterView
        }
    }
}

extension NNest where Base: UIScrollView {
    
    public func add(refreshHeaderAnimator animator: NRefreshProtocol = NRefreshViewAnimator(), refreshHeaderHandler handler: @escaping NRefreshHandler) {
        let rect = CGRect(x: 0, y: -animator.thresholdValue, width: self.base.width, height: animator.thresholdValue)
        let header = NRefreshHeaderView(frame: rect, refreshViewAnimator: animator, refreshHandler: handler)
        self.base.addSubview(header)
        self.base.refreshHeader = header
    }
    
    public func add(refreshFooterAnimator animator: NRefreshProtocol = NRefreshViewAnimator(), refreshFooterHandler handler: @escaping NRefreshHandler) {
        let rect = CGRect(x: 0, y: self.base.contentSize.height + self.base.contentInset.bottom, width: self.base.width, height: animator.thresholdValue)
        let footer = NRefreshFooterView(frame: rect, refreshViewAnimator: animator, refreshHandler: handler)
        self.base.addSubview(footer)
        self.base.refreshFooter = footer
    }
    
    public func startToRefresh() {
        guard let headerView = self.base.refreshHeader, !headerView.isRefreshing else {
            return
        }
        self.base.refreshHeader?.startRefreshing()
    }
    
    public func stopRefreshing() {
        guard let headerView = self.base.refreshHeader, headerView.isRefreshing else {
            return
        }
        self.base.refreshHeader?.stopRefreshing()
    }
    
    public func startToLoadMore() {
        guard let footerView = self.base.refreshFooter, !footerView.isRefreshing else {
            return
        }
        self.base.refreshFooter?.startRefreshing()
    }
    
    public func stopLoadingMore() {
        guard let footerView = self.base.refreshFooter, footerView.isRefreshing else {
            return
        }
        self.base.refreshFooter?.stopRefreshing()
    }
}
