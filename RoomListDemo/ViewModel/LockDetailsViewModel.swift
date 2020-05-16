//
//  LockDetailsViewModel.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation
import CoreData

class LockDetailsViewModel {
    var lockDetails: Box<CDLockDetails?> = Box(nil)
    
    func getLockDetails(roomId: Int) {
        loadSavedLockDetails(roomId: roomId) { [weak self] (cdLockDetails) in
            if let cdLockDetailsx = cdLockDetails {
                self?.lockDetails.value = cdLockDetailsx
            }else
            {
                self?.fetchLockDetailsFromServer(roomId: roomId) { [weak self] (dataExists) in
                    if dataExists
                    {
                        self?.getLockDetails(roomId: roomId)
                    }
                }
            }
        }
    }
}



// MARK: - Private Methods
private extension LockDetailsViewModel {
    func fetchLockDetailsFromServer(roomId: Int , callback: @escaping DataExists) {
        
        ServiceManagerSharedInstance.methodType(requestType: GET_REQUEST, url: GET_LOCK_DETAILS(roomId: "\(roomId)"), params: nil, paramsData: nil, completion: { [weak self] (_ response,_ responseData, _ statusCode) in
            if let lockDetailsData = responseData, statusCode == 200{
                let lockDetails = try? Shared_CustomJsonDecoder.decode(LockDetails.self, from: lockDetailsData)
                self?.saveLockDetailsToDb(lockDetails: lockDetails ?? LockDetails(), roomId: roomId, callback: callback)
            }
        }) {  (_ failure, _ statusCode) in
            print("Error happened \(failure.debugDescription)")
            callback(false)
        }
    }
    
    func saveLockDetailsToDb(lockDetails: LockDetails, roomId: Int , callback: @escaping DataExists) {
        DispatchQueue.main.async { [unowned self] in
            if let mac = lockDetails.MAC, mac.count > 0
            {
                self.deleteOlderLockDetails(roomId: roomId)
            }
            let cdLockDetails = CDLockDetails(context: AppDelegate_ViewContext)
            cdLockDetails.mac = lockDetails.MAC
            cdLockDetails.name = lockDetails.name
            cdLockDetails.desctn = lockDetails.description
            cdLockDetails.roomId = Int16(roomId)
            
            AppDelegate.shared.saveContext()
            callback(true)
        }
    }
    
    func loadSavedLockDetails( roomId: Int, callback:@escaping (_ cdLockDetails: CDLockDetails?) -> Void){
        let lockDetails = getAllLockDetails(roomId: roomId)
        callback(lockDetails.first)
    }
    
    
    func getAllLockDetails(roomId: Int) -> [CDLockDetails] {
        let predicate = NSPredicate(format: "roomId == %i", roomId)
        let fetchRequest = NSFetchRequest<CDLockDetails>(entityName: "CDLockDetails")
        fetchRequest.predicate = predicate
        do {
           let lockDetails = try AppDelegate_ViewContext.fetch(fetchRequest)
           return lockDetails
        } catch let error {
            print("Something wrong happened while fetching lock details ", error.localizedDescription)
            return []
        }
    }
}

extension LockDetailsViewModel{
    
    func deleteOlderLockDetails(roomId: Int) {
        let lockDetails = getAllLockDetails(roomId: roomId)
        for lockDetail in lockDetails {
            AppDelegate_ViewContext.delete(lockDetail)
        }
        AppDelegate.shared.saveContext()
    }
}
