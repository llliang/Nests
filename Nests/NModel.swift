//
//  NModel.swift
//  Nests
//
//  Created by liang on 2018/11/16.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation
import RealmSwift

/// Http 请求
public protocol NModelHttpable {
    
    associatedtype Entity
    /// 请求url
    var url: String { set get }
    
    var method: NHttpManager.NHttpMethod { set get }
    
    /// 参数
    var paramaters: Dictionary<String, Any> { set get }
    
    /// 请求开始
    typealias Start = () -> ()
    
    /// 请求结束
    typealias Success = (_ object: Entity) -> ()
    
    typealias Failure = (_ failure: Error) -> ()
    
    func loadData(start: Start, finished: @escaping Success, failure: @escaping Failure)
}

/// 缓存
public protocol NModelCaheable {
    var cacheTime: TimeInterval { get }
    func cache()
}

public extension NModelCaheable {
    
    var cacheTime: TimeInterval {
        return 0.0
    }
}

public extension NModelCaheable {
    
}

open class NModel<Entity: NEntityCodable>: NModelHttpable, NModelCaheable {
    open var url: String = ""

    open var paramaters = Dictionary<String, Any>()

    open var method: NHttpManager.NHttpMethod = .GET

    public required init(url: String, paramaters: Dictionary<String, Any> = Dictionary<String, Any>()) {
        self.url = url
        self.paramaters = paramaters
    }
    
    open func loadData(start: () -> (), finished: @escaping (Entity) -> (), failure: @escaping (Error) -> ()) {
        NHttpManager.requestAsynchronous(url: url, method: method, parameters: paramaters) { (result) in
            if result.isSuccess {
                let entity = try! Entity.toEntity(data: result.value as Any)
                finished((entity ?? nil)!)
            } else {
                failure(result.error!)
            }
        }
    }
    
    
    public func cache() {
    
    }
}

public enum NEntityCodableError: Error {
    case jsonError
}

public protocol NEntityCodable: Codable {
    func toJson() -> Data?
    static func toEntity(data: Any) throws -> Self?
}

public extension NEntityCodable {
    public func toJson() -> Data? {
        let encode = JSONEncoder()
        return try? encode.encode(self)
    }
    
    public static func toEntity(data: Any) throws -> Self? {
        let decoder = JSONDecoder()
        if !JSONSerialization.isValidJSONObject(data) {
            throw NEntityCodableError.jsonError
        }
        let objData = try? JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        do {
           let entity = try decoder.decode(Self.self, from: objData!)
            return entity
        } catch let error {
            throw error
        }
    }
}
