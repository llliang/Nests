//
//  NNetworkAuthorizationMonitoring.swift
//  Nests
//
//  Created by qlchat on 2019/11/30.
//  Copyright © 2019 TaiHao. All rights reserved.
//

import Foundation
import CoreTelephony

public class NNetworkAuthorizationMonitoring {
    public static func monitoring(state: @escaping ((_ state: CTCellularDataRestrictedState) -> Void)) {
        let cellData = CTCellularData()
        
        state(cellData.restrictedState)
        
        cellData.cellularDataRestrictionDidUpdateNotifier = { (s) in
            state(s)
        }
    }
}
