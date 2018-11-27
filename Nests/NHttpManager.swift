//
//  NHttpManager.swift
//  Nests
//
//  Created by liang on 2018/11/13.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation
import Alamofire

open class NHttpManager {
    
    /// 请求方法定义
    ///
    /// - POST: POST
    /// - GET: GET
    public enum NHttpMethod: String {
        case POST
        case GET
    }
    
    /// 请求返回
    ///
    /// - success: http正常请求 包括404等
    /// - failure: http请求错误 比如网络错误等
    public enum NHttpResult<Value> {
        case success(Value)
        case failure(Error)
        public var isSuccess: Bool {
            switch self {
            case .success:
                return true
            default:
                return false
            }
        }
        
        public var value: Value? {
            switch self {
            case .success(let value):
                return value
            default:
                return nil
            }
        }
        
        public var error: Error? {
            switch self {
            case .failure(let error):
                return error
            default:
                return nil
            }
        }
        
        public init(value: () throws -> Value) {
            do {
                self = try .success(value())
            } catch {
                self = .failure(error)
            }
        }
    }
    
    /// 异步请求接口
    ///
    /// - Parameters:
    ///   - url: 完整的URL
    ///   - method: NHttpMethod
    ///   - parameters: 请求参数
    ///   - completion: 请求回调
    /// - Returns: DataRequest Type
    @discardableResult open class func requestAsynchronous(url: String, method: NHttpMethod, parameters: Dictionary<String, Any>?,completion: @escaping (_ data: NHttpResult<Any?>) -> ()) -> DataRequest {
        var afMethod = HTTPMethod.get;
        
        switch method {
        case .POST:
            afMethod = .post
        case .GET:
            afMethod = .get
        }
        
        #if DEBUG
            print("url = \(url) \n parameters = \(parameters?.description ?? "参数无法解析成json"))")
        #endif

        return Alamofire.request(url, method: afMethod, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            var responseResult = NHttpResult.success(response.result.value)
        
            if response.result.isSuccess {
                responseResult = NHttpResult.success(response.result.value)
                    completion(responseResult)
            } else {
                responseResult = NHttpResult.failure(response.result.error!)
            }
        }
    }
}
