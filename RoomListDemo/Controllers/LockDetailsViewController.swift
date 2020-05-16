//
//  LockDetailsViewController.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

class LockDetailsViewController: UIViewController {
    
    private var lockDetailsViewModel = LockDetailsViewModel()
    var roomId: Int!
    var lockDetails: CDLockDetails!{
        didSet{
            tableViewx.reloadData()
        }
    }
    
    @IBOutlet weak var tableViewx: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Page2"
        lockDetailsViewModel.deleteOlderLockDetails(roomId: roomId)
        setupTableView()
        lockDetailsViewModel.getLockDetails(roomId: roomId)
        
        lockDetailsViewModel.lockDetails.bind { [weak self] (lockDetails) in
            self?.lockDetails = lockDetails
        }
    }
    
    fileprivate func setupTableView() {
        tableViewx.register(UINib(nibName: LockDetailsTableViewCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: LockDetailsTableViewCell.reuseIdentifier())
        tableViewx.dataSource = self
        tableViewx.delegate = self
        tableViewx.rowHeight = UITableView.automaticDimension
        tableViewx.estimatedRowHeight = 50
        tableViewx.separatorStyle = .none
        tableViewx.tableFooterView = UIView()
    }
    
}


extension LockDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = lockDetails {
            return 3
        }
        return 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LockDetailsTableViewCell.reuseIdentifier(), for: indexPath) as! LockDetailsTableViewCell
        cell.setUpLockDetailsTableViewCell(lockDetails: lockDetails, indexPath: indexPath)
        return cell
    }
    
}
