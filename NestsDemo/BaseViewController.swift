//
//  BaseViewController.swift
//  NestsDemo
//
//  Created by liang on 2018/12/4.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

protocol QLNoDataViewProvider {
    var emptyView: EmptyView? { get }
    
    func showEmptyView()
    
    func hideEmptyView()
}

extension QLNoDataViewProvider where Self: BaseViewController {
    
    func showEmptyView() {
        emptyView?.isHidden = false
        self.view.bringSubviewToFront(emptyView!)
    }
    
    func hideEmptyView() {
        emptyView?.isHidden = true
    }
}

class EmptyView: UIView {
    var actionHandler: (() -> ())?
}
