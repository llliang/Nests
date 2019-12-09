//
//  ViewController.swift
//  NestsDemo
//
//  Created by Neo on 2018/11/15.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import UIKit
import Nests

let url = "http://localhost:3000/mobile/test"

class QLEmptyView: EmptyView {
    
    lazy var btn: UIButton = {
        let b = UIButton(frame: self.bounds)
        b.addTarget(self, action: #selector(actions), for: .touchUpInside)
        return b
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.addSubview(btn)
    }
    
    @objc func actions() {
        self.actionHandler?()
    }
}

class ViewController: HttpTableViewController<Base>, QLNoDataViewProvider, UITableViewProxy {
    
    var number = 20
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    var emptyView: EmptyView?
    
//    override func initializeDataModel() {
//        dataModel = QLModel<Dog>(url: url)
//
//    }
    
    override func load(successful success: Bool) {
        if success {
            number += 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        
        
//        NDatabaseManager.write(object: lion)
        
        
//        let lion = NDatabaseManager.readObject(ofType: Lion.self, key: "peek")
//        if lion != nil {
//            NDatabaseManager.delete(object: lion!)
//
//        }
        
        
        
//        emptyView = QLEmptyView(frame: self.view.bounds)
//        emptyView?.backgroundColor = UIColor.red
//        emptyView?.isHidden = true
//        emptyView?.actionHandler = {
//            self.refreshData()
//        }
////        emptyView?.nest.add(actionHandler: {
////            self.refreshData()
////        })
////
//        self.view.addSubview(emptyView!)
//
//        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        btn.backgroundColor = UIColor.red
//        btn.addTarget(self, action: #selector(action), for: .touchUpInside)
//        view.addSubview(btn)
//        let dog = Dog()
//        dog.name = "大张伟"
//        dog.age = 30
////        NCacheManager.write(object: dog)
//        print("result = \(NCacheManager.readObjects(ofType: Dog.self, latestCount: 4))")
////        NCacheManager.readObjects(ofType: Dog.self, latestCount: 4, sort: .DESC)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("offset y = \(scrollView.contentOffset.y)")
    }

    @objc func action() {
    }
}

class QLModel<Entity: NEntityCodable>: NModel<BaseEntity<Entity>> {
    
    override var url: String {
        didSet {
            if !url.hasPrefix("http") {
                url = "http://localhost:3000" + url
            }
        }
    }
    
    var limited: Int = 20
    
    var baseEntity: BaseEntity<Entity>?
    
//    override func loadData(start: () -> (), finished: @escaping (BaseEntity<Entity>) -> (), failure: @escaping (Error) -> ()) {
//        super.loadData(start: start, finished: { (entity) in
//            self.baseEntity = entity
//
//        }, failure: failure)
//    }
}


class Base: NEntityCodable {
    
}

struct BaseEntity<Entity: NEntityCodable>: NEntityCodable {
  

    var code: Int = 0
    var message: String = ""
    var data: Entity?
    
}

//protocol QLModelCache: NModelCahe where {
//    <#requirements#>
//}



