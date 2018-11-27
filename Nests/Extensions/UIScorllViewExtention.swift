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

fileprivate var kRefreshHeaderKey: Void?
fileprivate var kRefreshFooterKey: Void?
///  header/footer
extension UIScrollView {
    
    public var refreshHeaderView: NRefreshHeaderView? {
        set {
            objc_setAssociatedObject(self, &kRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &kRefreshHeaderKey) as? NRefreshHeaderView
        }
    }
    
    public var refreshFooterView: NRefreshFooterView? {
        set {
            objc_setAssociatedObject(self, &kRefreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &kRefreshFooterKey) as? NRefreshFooterView
        }
    }
}

extension NNest where Base: UIScrollView {
    
}
