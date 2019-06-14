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
    
    associatedtype ModelEntity
    /// 请求url
    var url: String { set get }
    
    var method: NHttpManager.NHttpMethod { set get }
    
    /// 参数
    var paramaters: Dictionary<String, Any> { set get }
    
    var task: URLSessionTask? { get }
    
    /// 请求开始
    typealias Start = () -> ()
    
    /// 请求结束
    typealias Success = (_ object: ModelEntity) -> ()
    
    typealias Failure = (_ failure: Error) -> ()
    
    func loadData(start: Start, finished: @escaping Success, failure: @escaping Failure)
}

/// 缓存
public protocol NModelCache {
    
    associatedtype Entity
    var cacheTime: TimeInterval { get }
    func cache()
    func loadCache() -> Entity?
}

open class NModel<ModelEntity: NEntityCodable>: NModelHttpable {
    public var task: URLSessionTask?
    
    open var url: String = ""

    public var paramaters = Dictionary<String, Any>()

    open var method: NHttpManager.NHttpMethod = .GET
    
    open var additionalParamaters = Dictionary<String, Any>() {
        didSet {
            self.paramaters = self.additionalParamaters.merging(paramaters, uniquingKeysWith: { (_, new) -> Any in
                return new;
            })
        }
    }

    public required init(url: String, paramaters: Dictionary<String, Any> = Dictionary<String, Any>()) {
        self.url = url
        
        self.paramaters = paramaters.merging(self.additionalParamaters, uniquingKeysWith: { (_, new) -> Any in
            return new
        })
    }
    
    open func loadData(start: () -> (), finished: @escaping (ModelEntity?) -> (), failure: @escaping (Error) -> ()) {
        task = NHttpManager.requestAsynchronous(url: url, method: method, parameters: paramaters) { (result) in
            if result.isSuccess {
                let entity = try! ModelEntity.toEntity(data: result.value as Any)
                finished(entity)
            } else {
                failure(result.error!)
            }
        }
    }
    
    open func cancel() {
        task?.cancel()
    }
}

