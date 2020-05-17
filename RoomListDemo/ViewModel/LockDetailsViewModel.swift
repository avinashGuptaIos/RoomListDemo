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
        START_LOADING_VIEW()
        if Utils.isInternetAvailable() {
            fetchLockDetailsFromServer(roomId: roomId) { [weak self] (dataExists) in
                if dataExists
                {
                    STOP_LOADING_VIEW()
                    self?.loadSavedLockDetails(roomId: roomId) { [weak self] (cdLockDetails) in
                        if let cdLockDetailsx = cdLockDetails {
                            self?.lockDetails.value = cdLockDetailsx
                        }
                    }
                }
            }
        }
        else
        {
        loadSavedLockDetails(roomId: roomId) { [weak self] (cdLockDetails) in
            if let cdLockDetailsx = cdLockDetails {
                STOP_LOADING_VIEW()
                self?.lockDetails.value = cdLockDetailsx
            }
        }
        }
    }
    
    // DB Priority Flow
    
//    func getLockDetails(roomId: Int) {
//        START_LOADING_VIEW()
//        loadSavedLockDetails(roomId: roomId) { [weak self] (cdLockDetails) in
//            if let cdLockDetailsx = cdLockDetails {
//                STOP_LOADING_VIEW()
//                self?.lockDetails.value = cdLockDetailsx
//            }else
//            {
//                self?.fetchLockDetailsFromServer(roomId: roomId) { [weak self] (dataExists) in
//                    if dataExists
//                    {
//                        STOP_LOADING_VIEW()
//                        self?.getLockDetails(roomId: roomId)
//                    }
//                }
//            }
//        }
//    }
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
        DataManagerSharedInstance.saveLockDetailsToDb(lockDetails: lockDetails, roomId: roomId, callback: callback)
    }
    
    func loadSavedLockDetails( roomId: Int, callback:@escaping (_ cdLockDetails: CDLockDetails?) -> Void){
        DataManagerSharedInstance.loadSavedLockDetails(roomId: roomId, callback: callback)
    }
    
}
