//
//  ViewController.swift
//  NestsDemo
//
//  Created by Neo on 2018/11/15.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import UIKit
import Nests

let url = "http://localhost:3000/mobile/test"

class QLEmptyView: EmptyView {
    
    lazy var btn: UIButton = {
        let b = UIButton(frame: self.bounds)
        b.addTarget(self, action: #selector(actions), for: .touchUpInside)
        return b
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.addSubview(btn)
    }
    
    @objc func actions() {
        self.actionHandler?()
    }
}

class ViewController: UIViewController {
    
    
}




