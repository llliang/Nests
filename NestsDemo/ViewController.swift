//
//  ViewController.swift
//  NestsDemo
//
//  Created by liang on 2018/11/15.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import UIKit
import Nests
import RealmSwift

let url = "http://localhost:3000/mobile/test"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        

        
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        btn.setTitle("哈哈", for: .normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(action), for: .touchUpInside)
        self.view.addSubview(btn)
    }

    @objc func action() {
        
        let model = QLModel<Dog>(url: url)
        model.url = url
        model.method = NHttpManager.NHttpMethod.GET
        model.loadData(start: {

        }, finished: { (entity) in
            NCacheManager.write(object: entity)
        }) { (error) in

        }
        
        NHttpManager.requestAsynchronous(url: url, method: NHttpManager.NHttpMethod.GET, parameters: nil) { (result) in
            if result.isSuccess {
                do {
                    let entity = try Dog.toEntity(data: result.value! as Any)
                    print("entity = \(entity!)")
                } catch let error {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
}

class QLModel<Entity: NEntityCodable>: NModel<Entity> {
    override var url: String {
        didSet {
            if !url.hasPrefix("http") {
                url = "http://localhost:3000" + url
            }
        }
    }
}

class Dog: Object, NEntityCodable {
   @objc dynamic var name: String = ""
   @objc dynamic var age: Int = 0
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

