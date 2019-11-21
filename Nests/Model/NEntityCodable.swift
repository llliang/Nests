//
//  NEntityCodable.swift
//  Nests
//
//  Created by liang on 2018/12/14.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation

extension Decodable {
    public static func toEntity(data: Any) -> Self? {
        let decoder = JSONDecoder()
        if !JSONSerialization.isValidJSONObject(data) {
            return nil
        }
        let objData = try? JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        do {
            let entity = try decoder.decode(Self.self, from: objData!)
            return entity
        } catch {
            return nil
        }
    }
}
