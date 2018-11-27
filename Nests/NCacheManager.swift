//
//  NCacheManager.swift
//  Nests
//
//  Created by liang on 2018/11/16.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import Foundation
import RealmSwift

open class NCacheManager {
    
    let realm: Realm = {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        path = path! + "/Cache"
        if !FileManager.default.fileExists(atPath: path!) {
           try! FileManager.default.createDirectory(at: URL(fileURLWithPath: path!), withIntermediateDirectories: true, attributes: nil)
        }
        path = path! + "/caches.realm"
        print("path = \(path ?? "数据库路径错误") \n\n\n")
        var config = Realm.Configuration(fileURL: URL(fileURLWithPath: path!))
        return try! Realm(configuration: config)
    }()
    
    public static let manager = NCacheManager()
    
    /// 新添加或者更新单条数据
    ///
    /// - Parameter object: 写入的数据
    public class func write(object: Object) {
        let manager  = NCacheManager.manager;
        do {
            try manager.realm.write {
                manager.realm.add(object, update: true)
            }
        } catch let error {
            print("写入数据库出错 \(error)")
        }
    }
    
    /// 新添加或者更新一组数据
    ///
    /// - Parameter objects: 待插入的一组数据
    public class func write(objects: [Object]) {
        let manager  = NCacheManager.manager;
        do {
            try manager.realm.write {
                manager.realm.add(objects, update: true)
            }
        } catch let error {
            print("写入数据库出错 \(error)")
        }
    }
    
    /// 删除单条数据
    ///
    /// - Parameter object: 待删除数据
    public class func delete(object: Object) {
        NCacheManager.manager.realm.delete(object)
    }
    
    /// 删除一组数据
    ///
    /// - Parameter objects: 一组数据
    public class func delete(objects: [Object]) {
        NCacheManager.manager.realm.delete(objects)
    }
    
    /// 删除一个类型所有数据
    ///
    /// - Parameter ofType: 数据类型
    public class func delete(ofType: Object.Type) {
        let manager = NCacheManager.manager
        manager.realm.delete(manager.realm.objects(ofType))
    }
    
    /// 根据主键读取一条数据
    ///
    /// - Parameters:
    ///   - ofType: 数据类型 Object 及其子类
    ///   - key: 主键
    /// - Returns: 返回的类型实例
    public class func readObject<T: Object>(ofType: T.Type, key: String) -> T? {
        return NCacheManager.manager.realm.object(ofType: ofType, forPrimaryKey: key)
    }
    
    /// 根据一个类型的所有数据
    ///
    /// - Parameter ofType: 数据类型 Object 及其子类
    /// - Returns: ofType 对应的类型的数组
    public class func readObjects<T>(ofType: T.Type) -> [T]?  where T: Object {
        let results = NCacheManager.manager.realm.objects(ofType)
        return results.map { (element) -> T in
            return element
        }
    }
    
    /// 根据一个类型的最新指定数量的数据
    ///
    /// - Parameters:
    ///   - ofType: 数据类型 Object 及其子类
    ///   - latestCount: 最新的数量
    /// - Returns: 对应的类型的数组
    public class func readObjects<T>(ofType: T.Type, latestCount: UInt) -> [T]?  where T: Object {
        let results = NCacheManager.manager.realm.objects(ofType).filter("limited = %ld", latestCount)
        return results.map { (element) -> T in
            return element
        }
    }
}

