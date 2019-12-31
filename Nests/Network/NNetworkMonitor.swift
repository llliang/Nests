//
//  NNetworkMonitor.swift
//  Nests
//
//  Created by qlchat on 2019/11/30.
//  Copyright © 2019 TaiHao. All rights reserved.
//

import Foundation
import CoreTelephony
import Alamofire

public final class NNetworkMonitor {
    
    public static let shared = NNetworkMonitor()
    
    private var isMonitoringAuthorization = false
    
    public var authorizationState = CTCellularDataRestrictedState.restrictedStateUnknown
    
    private lazy var reachabilityManager = NetworkReachabilityManager(host: "www.baidu.com")
    private var isMonitoringReachability = false
    
    public var reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus {
        if let status = reachabilityManager?.networkReachabilityStatus {
            return status
        }
        return .unknown
    }
    
    public var isReachable: Bool {
        return reachabilityManager?.isReachable ?? false
    }

    public var isReachableOnWWAN: Bool {
        return reachabilityManager?.isReachableOnWWAN ?? false
    }
       
    public var isReachableOnEthernetOrWiFi: Bool {
        return reachabilityManager?.isReachableOnEthernetOrWiFi ?? false
    }
    
    /// 监听网络授权状态
    public func authorizationMonitoring(authorizationState: @escaping ((_ state: CTCellularDataRestrictedState) -> Void)) {
        if isMonitoringAuthorization {
            return
        }
        isMonitoringAuthorization = true
        
        let cellData = CTCellularData()
        self.authorizationState = cellData.restrictedState
        authorizationState(self.authorizationState)
        
        cellData.cellularDataRestrictionDidUpdateNotifier = { (state) in
            self.authorizationState = state
            authorizationState(state)
        }
    }

    /// 监听当前网络模式状态
    public func reachabilityMonitoring(reachabilityStatus: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void) {
        
        if isMonitoringReachability {
            return
        }
        
        isMonitoringReachability = true
        
        reachabilityManager?.listener = { status in
            reachabilityStatus(status)
        }
        reachabilityManager?.startListening()
    }
    
    public func stopReachabilityMonitoring() {
        reachabilityManager?.stopListening()
        isMonitoringReachability = false
    }
    
    public var networkModel: String {
        if isReachableOnEthernetOrWiFi {
            return "WIFI"
        } else if isReachableOnWWAN {
            let info = CTTelephonyNetworkInfo()
            
            if info.currentRadioAccessTechnology == CTRadioAccessTechnologyGPRS {
                return "2G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyEdge {
                return "2G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyWCDMA {
                return "3G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyHSDPA {
                return "3G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyHSUPA {
                return "3G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyCDMA1x {
                return "3G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyCDMAEVDORev0 {
                return "3G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyCDMAEVDORevA {
                return "3G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyCDMAEVDORevB {
                return "3G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyeHRPD {
                return "3G"
            } else if info.currentRadioAccessTechnology == CTRadioAccessTechnologyLTE {
                return "4G"
            }
        }
        
        return "unknown"
    }
}
