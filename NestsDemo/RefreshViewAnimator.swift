//
//  RefreshViewAnimator.swift
//  NestsDemo
//
//  Created by Neo on 2018/12/5.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import UIKit
import Nests
import Lottie

class RefreshViewAnimator: UIView, NRefreshProtocol, NNestImpactorProtocol {
    
    lazy var animatorView: AnimationView = {
        let aView = AnimationView(name: "loading")
        aView.loopMode = .loop
        return aView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        animatorView.frame.size = CGSize(width: 20, height: 20)
        animatorView.center = CGPoint(x: self.width/2.0, y: self.height/2.0)
        self.addSubview(animatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var thresholdValue: CGFloat = 60
    
    var insets: UIEdgeInsets = .zero
    
    var state: NRefreshState = .canDragRefresh
    
    func animationBegin(refreshView: NRefreshView) {
        animatorView.play()
    }
    
    func animationEnd(refreshView: NRefreshView) {
        animatorView.stop()
    }
    
    func refresh(view: NRefreshView, stateDidChanged state: NRefreshState) {
        guard state != self.state else {
            return
        }
        self.state = state
        switch state {
        case .canDragRefresh:
            animatorView.stop()
            break
        case .refreshing:
            animatorView.play()
        case .releaseToRefresh:
            self.impact()
            animatorView.play()
        default:
            break
        }
    }
    
    func refresh(view: NRefreshView, progressDidChange progress: CGFloat) {
        
    }
}
