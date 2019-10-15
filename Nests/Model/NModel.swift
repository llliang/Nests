//
//  NModel.swift
//  Nests
//
//  Created by liang on 2018/11/16.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation

/// Http 请求
public protocol NModelHttpable {
    
    associatedtype ModelEntity: NEntityCodable
    
    /// 请求url
    var url: String { set get }
    
    var method: NHttpManager.NHttpMethod { get }
    
    /// 参数
    var paramaters: Dictionary<String, Any> { get }
    
    /// 请求开始
    typealias Start = () -> ()
    
    /// 请求结束
    typealias Success = (_ object: ModelEntity?) -> ()
    
    typealias Failure = (_ failure: Error) -> ()
    
    func loadData(start: Start, finished: @escaping Success, failure: @escaping Failure) -> URLSessionTask?
}

/// 缓存
public protocol NModelCache {
    associatedtype ModelEntity: NEntityCodable
    
    var cacheTime: TimeInterval { get }
    var cacheKey: String? { get }
    func loadCache() -> ModelEntity?
}

open class NModel<ModelEntity: NEntityCodable>: NModelHttpable, NModelCache {
    
    public var cacheKey: String?
    
    public var cacheTime: TimeInterval = 0
    
    public func loadCache() -> ModelEntity? {
        return nil
    }
    
    
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
    
    open func loadData(start: () -> (), finished: @escaping (ModelEntity?) -> (), failure: @escaping (Error) -> ()) -> URLSessionTask? {
        task = NHttpManager.requestAsynchronous(url: url, method: method, parameters: paramaters) { (result) in
            if result.isSuccess {
                
                let entity = try? ModelEntity.toEntity(data: result.value as Any)
                finished(entity)
                
                guard let cacheKey = self.cacheKey else {
                    return
                }
                
                NCacheManager.manager.setCache(cache: entity, forKey: cacheKey, expireInterval: self.cacheTime)
            } else {
                failure(result.error!)
            }
        }
        return task
    }
    
    open func cancel() {
        task?.cancel()
    }
}

