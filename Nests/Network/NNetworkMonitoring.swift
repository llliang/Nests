//
//  NNetworkMonitoring.swift
//  Nests
//
//  Created by qlchat on 2019/11/30.
//  Copyright © 2019 TaiHao. All rights reserved.
//

import Foundation
import CoreTelephony
import Alamofire

public class NNetworkMonitoring {
    
    static let shared = NNetworkMonitoring()
    
    public func AuthorizationMonitoring(authorizationState: @escaping ((_ state: CTCellularDataRestrictedState) -> Void)) {
        let cellData = CTCellularData()
        
        authorizationState(cellData.restrictedState)
        
        cellData.cellularDataRestrictionDidUpdateNotifier = { (state) in
            authorizationState(state)
        }
    }
    
    public func reachabilityMonitoring(reachabilityStatus: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void) {
        let manager = NetworkReachabilityManager(host: "www.baidu.com")
        manager?.listener = { status in
            reachabilityStatus(status)
        }
    }
}
