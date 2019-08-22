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
    
    public static let instance = NCacheManager()
    
    private let key = Expression<String>("key")
    private let data = Expression<String>("data")
    private let expire = Expression<Date>("expire")
    
    public enum NCacheDbError: Error {
        case pathError
    }
    
    // 数据库path
    private var dbPath: String?
    
    override init() {
        super.init()
        _ = try? db?.run(kvTable.create(ifNotExists: false, block: { (t) in
            t.column(key, primaryKey: true)
            t.column(data)
            t.column(expire)
        }))
        
        _ = try? db?.run(kvTable.filter(expire < Date()).delete())
    }
    
    public class func config(dbPath: String?) throws {
        let instance = NCacheManager.instance
        if dbPath == nil {
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            guard let docPath = documentPath else {
                throw NCacheDbError.pathError
            }
            instance.dbPath = docPath
        } else {
            instance.dbPath = dbPath
        }
    }
    
    lazy var db: Connection? = {
        let dbPath = self.dbPath!
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            try? fileManager.createDirectory(atPath: dbPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        return try? Connection(dbPath)
    }()
    
    // 键值对数据库
    private var kvTable = Table("kvTable")
    
    @discardableResult
    public func setCache<Entity: NEntityCodable>(cache: Entity?, forKey: String, expireInterval: TimeInterval = 0) -> Bool {
        guard let cache = cache else {
            return false
        }
        let d = cache.toJson()
        let string = String(data: d!, encoding: String.Encoding.utf8)
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
            print(error)
            return false
        }
    }
    
    public func removeCache(forKey: String) throws {
        try db?.run(kvTable.filter(key == forKey).delete())
    }
    
    public func cache<Entity: NEntityCodable>(forKey: String) -> Entity? {
        let read = kvTable.filter(key == forKey)
        
        var results = Array<Row>()
        
        for item in (try! db?.prepare(read))! {
            results.append(item)
        }
        
        let string: String? = results.first?[data]
        
        if (string != nil) {
            return try? JSONDecoder().decode(Entity.self, from: (string?.data(using: String.Encoding.utf8))!)
        }
        return nil
    }
}
