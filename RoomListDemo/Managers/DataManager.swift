//
//  DataManager.swift
//  RoomListDemo
//
//  Created by mac on 17/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation
import CoreData

let DataManagerSharedInstance = DataManager.shared

class DataManager {
    private init(){ }
    static let shared = DataManager()
    
    private let dataBaseQueue = DispatchQueue(label: "dataBaseQueue", attributes: .concurrent)
    
    //MARK: RoomList CRUD Operations
    func saveRoomListToDb(roomList: [RoomData], callback: @escaping DataExists) {
        dataBaseQueue.async { [weak self] in
            if roomList.count > 0{
                self?.deleteAllObjects(entityName: "CDRoomData")
            }
            for room in roomList{
                let data = try? Shared_CustomJsonEncoder.encode(room)
                let cdRoomData = CDRoomData(context: AppDelegate_ViewContext)
                cdRoomData.room = data
            }
            AppDelegate.shared().saveContext()
            callback(roomList.count > 0)
        }
    }
    
    func loadSavedRoomList(callback:@escaping (_ roomList: [CDRoomData]?) -> Void){
        dataBaseQueue.async(flags: .barrier) {
            let fetchRequest =  NSFetchRequest<CDRoomData>(entityName: "CDRoomData")
            let rooms = try? AppDelegate_ViewContext.fetch(fetchRequest)
            callback(rooms)
        }
    }
    
    //MARK: Delete Any Entity using Batch Request
    
    func deleteAllObjects(entityName: String) {
        dataBaseQueue.sync {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try AppDelegate_ViewContext.execute(batchDeleteRequest)
                AppDelegate.shared().saveContext()
            } catch let error {
                print("Error happened while deleting the records \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: LockDetails CRUD Operations

    func saveLockDetailsToDb(lockDetails: LockDetails, roomId: Int , callback: @escaping DataExists) {
        dataBaseQueue.async { [weak self] in
            if let mac = lockDetails.MAC, mac.count > 0
            {
                self?.deleteOlderLockDetails(roomId: roomId)
            }
            let cdLockDetails = CDLockDetails(context: AppDelegate_ViewContext)
            cdLockDetails.mac = lockDetails.MAC
            cdLockDetails.name = lockDetails.name
            cdLockDetails.desctn = lockDetails.description
            cdLockDetails.roomId = Int16(roomId)
            
            AppDelegate.shared().saveContext()
            callback(true)
        }
    }
    
    func loadSavedLockDetails( roomId: Int, callback:@escaping (_ cdLockDetails: CDLockDetails?) -> Void){
        dataBaseQueue.async(flags: .barrier) { [weak self] in
            let lockDetails = self?.getAllLockDetails(roomId: roomId)
            callback(lockDetails?.first)
        }
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
    
    func deleteOlderLockDetails(roomId: Int) {
        dataBaseQueue.sync {
            let lockDetails = getAllLockDetails(roomId: roomId)
            for lockDetail in lockDetails {
                AppDelegate_ViewContext.delete(lockDetail)
            }
            AppDelegate.shared().saveContext()
        }
    }
}
