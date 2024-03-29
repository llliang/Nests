//
//  NHttpManager.swift
//  Nests
//
//  Created by Neo on 2018/11/13.
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
        case failure(NError)
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
        
        public var error: NError? {
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
                self = .failure(NError(reason: error.localizedDescription))
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
    @discardableResult open class func requestAsynchronous(url: URLConvertible, method: NHttpMethod, parameters: Dictionary<String, Any>?, httpHeaders: Dictionary<String, String>? = nil, completion: @escaping (_ data: NHttpResult<Any?>) -> ()) -> URLSessionTask? {
        var afMethod = HTTPMethod.get;
        
        switch method {
        case .POST:
            afMethod = .post
        case .GET:
            afMethod = .get
        }
       
        return AF.request(url, method: afMethod, parameters: parameters, encoding: JSONEncoding.default, headers: self.translate(header: httpHeaders)).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    completion(NHttpResult.success(value))
                case .failure(let error):
                    completion(NHttpResult.failure(NError(reason: error.localizedDescription)))
            }
        }.task
    }
    
    class func translate(header: Dictionary<String, String>?) -> HTTPHeaders? {
        if let h = header {
            return HTTPHeaders(h)
        }
        return nil
    }
    
    @discardableResult open class func download(url: URLConvertible,
    method: NHttpMethod,
    to destination: URL,
    progress: @escaping ((Float) -> Void),
    completion: @escaping (_ data: NHttpResult<Any?>) -> ()) -> DownloadRequest {
        
        var afMethod = HTTPMethod.get;
        switch method {
        case .POST:
            afMethod = .post
        case .GET:
            afMethod = .get
        }
        
        return AF.download(url, method: afMethod, to: { (url, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
            return (destination, [.createIntermediateDirectories, .removePreviousFile])
        }).responseData { (response) in
            switch response.result {
                case .success(let value):
                    completion(NHttpResult.success(value))
                case .failure(let error):
                    completion(NHttpResult.failure(NError(reason: error.localizedDescription)))
            }
        }.downloadProgress { (p) in
            let total = p.totalUnitCount
            if total > 0 {
                progress(Float(p.completedUnitCount)/Float(total))
            } else {
                progress(Float(0))
            }
        }
    }
}
