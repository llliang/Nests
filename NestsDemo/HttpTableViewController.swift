//
//  HttpTableViewController.swift
//  NestsDemo
//
//  Created by liang on 2018/12/3.
//  Copyright © 2018 TaiHao. All rights reserved.
//

import UIKit
import Nests
//import RealmSwift

typealias UITableViewProxy = UITableViewDelegate & UITableViewDataSource

class HttpTableViewController<Entity: NEntityCodable>: BaseViewController {
    
    var isRefresh = true
    
    var dataModel: QLModel<Entity>?
    var dataSource: Entity?
    
    var tableView: UITableView!
    
    var enableRefresh = true
    var enableLoadMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeTableView()
        
        self.initializeDataModel()
//        isRefresh = true
        self.loadData(isManual: false)
    }
    
    func initializeTableView() {
        tableView = UITableView(frame: self.tableViewRect(), style: self.tableViewStyle())
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.addSubview(tableView)
        
        if enableRefresh {
            tableView.nest.add(refreshHeaderAnimator: RefreshViewAnimator(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 60)), refreshHeaderHandler: { [weak self] in
                
                self?.refreshData()
            })
        }
        
        if enableLoadMore {
            tableView.nest.add(refreshFooterAnimator: RefreshViewAnimator(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 60)), refreshFooterHandler: { [weak self] in
                self?.loadData()
            })
        }
    }
    
    func initializeDataModel() {
        dataModel = QLModel(url: "")
    }
    
    func loadData(isManual: Bool = true) {
        print("isRefresh = \(isRefresh)")
        dataModel?.loadData(start: {
            
        }, finished: {[weak self] (modelEntity) in
            
            defer {
                if isManual {
                    if let isRefresh = self?.isRefresh, isRefresh == true {
                        self?.tableView.nest.stopRefreshing()
                    } else {
                        self?.tableView.nest.stopLoadingMore()
                    }
                }
                self?.load(successful: true)
                
                self?.isRefresh = false
                self?.tableView.reloadData()
            }
            
            if let isRefresh = self?.isRefresh, isRefresh == true {
                self?.dataSource = modelEntity?.data
            } else {
                guard var dataSource = self?.dataSource as? [NEntityCodable],let datas = modelEntity?.data as? [NEntityCodable] else {
                    self?.dataSource = modelEntity?.data
                    return
                }
                self?.dataSource = dataSource.append(contentsOf: datas) as? Entity
                if datas.count == 0 {
                    self?.tableView.refreshFooter?.noMoreData = true
                }
            }
        }) { [weak self] (error) in
            
            print("http request error：\(error.localizedDescription)")
            defer {
                self?.load(successful: false)
                
                self?.isRefresh = false
                self?.tableView.reloadData()
            }
            
            if !isManual {
                self?.isRefresh = false
                return
            }
            
            if let isRefresh = self?.isRefresh, isRefresh == true {
                self?.tableView.nest.stopRefreshing()
            } else {
                self?.tableView.nest.stopLoadingMore()
            }
        }
    }
    
    func refreshData() {
        isRefresh = true
        self.loadData()
    }
    
    open func load(successful success: Bool) {
        
    }
    
    public func tableViewRect() -> CGRect {
        return view.bounds
    }
    
    public func tableViewStyle() -> UITableView.Style {
        return .plain
    }
}

protocol ScrollViewHttpable {
    associatedtype Entity: NEntityCodable
    var dataModel: NModel<QLModelEntity<Entity>> {get}
    func loadData()
}

extension ScrollViewHttpable {
    
}

protocol ScrollViewRefresh: ScrollViewHttpable {
    func refreshData()
}

extension ScrollViewRefresh where Self: UIViewController {
    func refreshData() {
        
    }
}

protocol ScrollViewLoadMore: ScrollViewHttpable {
    func loadMore()
}

extension ScrollViewLoadMore {
    func loadMore() {
        
    }
}

struct QLModelEntity<Entity: NEntityCodable>: NEntityCodable {
    
}
