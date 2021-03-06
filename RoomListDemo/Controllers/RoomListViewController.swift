//
//  RoomListViewController.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

class RoomListViewController: UIViewController {

    private var roomListViewModel = RoomListViewModel()
    private var roomDataArray = [RoomData]()
    @IBOutlet weak var tableViewx: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(RoomListViewController.handleRefresh),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching room list ...")
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Page1"
//        roomListViewModel.deleteAllObjects(entityName: "CDRoomData") //Not required for Server to DB flow
        setupTableView()
        roomListViewModel.getRoomList()
        
        roomListViewModel.rooms.bind { [weak self] (rooms) in
            DispatchQueue.main.async {
                self?.roomDataArray.removeAll()
                self?.roomDataArray = rooms.map{ try! Shared_CustomJsonDecoder.decode(RoomData.self, from: $0.room ?? Data()) }
                self?.tableViewx.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserverForInternetConnectivity()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverForInternetConnectivity()
    }
    
    
    fileprivate func setupTableView() {
        tableViewx.register(UINib(nibName: RoomDataTableViewCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: RoomDataTableViewCell.reuseIdentifier())
        tableViewx.dataSource = self
        tableViewx.delegate = self
        tableViewx.rowHeight = UITableView.automaticDimension
        tableViewx.estimatedRowHeight = 50
        tableViewx.tableFooterView = UIView()
        tableViewx.addSubview(refreshControl)
    }
    
    //MARK: Pull to Refresh Action
    
    @objc func handleRefresh() {
        roomListViewModel.getRoomList()
    }
    
    // MARK: - InternetConnection_Observer
    override func gotInternetConnectivity() {
        super.gotInternetConnectivity()
        roomListViewModel.getRoomList()
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate

extension RoomListViewController: UITableViewDataSource, UITableViewDelegate{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomDataArray.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoomDataTableViewCell.reuseIdentifier(), for: indexPath) as! RoomDataTableViewCell
        cell.roomData = roomDataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let roomId = roomDataArray[indexPath.row].room?.id , let lockDetailsVc = storyboard?.instantiateViewController(identifier: "LockDetailsViewController") as? LockDetailsViewController
        {
            lockDetailsVc.roomId = roomId
            navigationController?.pushViewController(lockDetailsVc, animated: true)
        }
    }
}
