//
//  NCacheManager.swift
//  Nests
//
//  Created by qlchat on 2019/8/14.
//  Copyright © 2019 TaiHao. All rights reserved.
//

import Foundation
import SQLite

open class NCacheManager: NSObject {
    
    /// 数据库地址
    static var dbPath: String?
    
    public static let manager = NCacheManager()
    
    private let key = Expression<String>("key")
    private let data = Expression<String>("data")
    private let expire = Expression<Date>("expire")
    
    public enum NCacheDbError: Error {
        case patNError
    }
    
    /// 数据库对象
    var db: Connection?
    
    override init() {
        super.init()
        
        var dbPath = NCacheManager.dbPath
        
        if dbPath == nil {
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            
            guard let docPath = documentPath else {
                return
            }
            
            dbPath = docPath + "/cache"
        }
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath!) {
            do {
                try fileManager.createDirectory(atPath: dbPath!, withIntermediateDirectories: true, attributes: nil)
            } catch {
//                print("error = \(error.localizedDescription)")
            }
        }
        
        do {
            try db = Connection(dbPath! + "/db.sqlite")
        } catch let error {
//            print("error = \(error.localizedDescription)")
        }
        
        do {
            try db?.run(kvTable.create(ifNotExists: false, block: { (t) in
                t.column(key, primaryKey: true)
                t.column(data)
                t.column(expire)
            }))
        } catch let error {
//            print("error = \(error.localizedDescription)")
        }
        
        _ = try? db?.run(kvTable.filter(expire < Date()).delete())
    }
    
    public class func config(dbPath: String?) throws {
        NCacheManager.dbPath = dbPath
    }
    
    // 键值对数据库
    lazy var kvTable = Table("kvTable")
    
    @discardableResult
    public func setCache<Entity: Codable>(cache: Entity?, forKey: String, expireInterval: TimeInterval = 0) -> Bool {
        
        guard let cache = cache else {
            return false
        }

        do {
            let encode = JSONEncoder()
            let d = try encode.encode(cache)
            let string = String(data: d, encoding: String.Encoding.utf8)
            
            do {
                // 默认不过期
                var expireDate = Date.distantFuture

                // 若传入 expireInterval 大于0 则以传入时间为准
                if expireInterval > 0 {
                    expireDate = Date().addingTimeInterval(expireInterval)
                }
                try db?.run(kvTable.insert(or: .replace, key <- forKey, data <- string!, expire <- expireDate))
                return true
            } catch  {
//                print("写入数据库类型:\(Entity.self)出错，错误为:\(error.localizedDescription)")
                return false
            }
        } catch {
//            print("encode类型:\(Entity.self)出错，错误为:\(error.localizedDescription)---iOS13以下版本基础数据类型JSONEncoder有bug无法encode decode 建议基础数据类型不要用这个存")
            return false
        }
    }
    
    public func removeCache(forKey: String) throws {
        try db?.run(kvTable.filter(key == forKey).delete())
    }
    
    public func cache<Entity: Codable>(forKey: String) -> Entity? {
        let read = kvTable.filter(key == forKey)
        
        var results = Array<Row>()
        
        do {
            if let items = try db?.prepare(read) {
                for item in items {
                    results.append(item)
                }
            }
        } catch {

        }
        
        let string: String? = results.first?[data]
        
        if (string != nil) {
            guard let data = string?.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            do {
                return try JSONDecoder().decode(Entity.self, from: data)
            } catch {
                return nil
            }
        }
        return nil
    }
}
