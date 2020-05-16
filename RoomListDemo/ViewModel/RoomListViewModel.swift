//
//  RoomListViewModel.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation
import CoreData


class RoomListViewModel {
    
    var rooms: Box<[CDRoomData]> = Box([])
    
    func getRoomList() {
        loadSavedRoomList { [weak self] (roomListx) in
            if let roomList = roomListx , roomList.count > 0 {
                self?.rooms.value = roomList
            }else
            {
                self?.fetchRoomListFromServer { [weak self] (dataExists) in
                    if dataExists
                    {
                        self?.getRoomList()
                    }
                }
            }
        }
    }
}


// MARK: - Private Methods
private extension RoomListViewModel {
    func fetchRoomListFromServer(callback: @escaping DataExists) {
        
        ServiceManagerSharedInstance.methodType(requestType: GET_REQUEST, url: GET_ROOM_LIST(), params: nil, paramsData: nil, completion: { [weak self] (_ response,_ responseData, _ statusCode) in
            if let roomListData = responseData, statusCode == 200{
                let roomList = try? Shared_CustomJsonDecoder.decode(RoomList.self, from: roomListData)
                self?.saveRoomListToDb(roomList: roomList?.data ?? [], callback: callback)
            }
        }) {  (_ failure, _ statusCode) in
            print("Error happened \(failure.debugDescription)")
            callback(false)
        }
    }
    
    func saveRoomListToDb(roomList: [RoomData], callback: @escaping DataExists) {
        DispatchQueue.main.async { [unowned self] in
            if roomList.count > 0{
                self.deleteAllObjects(entityName: "CDRoomData")
            }
            for room in roomList{
                let data = try? Shared_CustomJsonEncoder.encode(room)
                let cdRoomData = CDRoomData(context: AppDelegate_ViewContext)
                cdRoomData.room = data
            }
            AppDelegate.shared.saveContext()
            callback(roomList.count > 0)
        }
    }
    
    func loadSavedRoomList(callback:@escaping (_ roomList: [CDRoomData]?) -> Void){
        let fetchRequest =  NSFetchRequest<CDRoomData>(entityName: "CDRoomData")
        let rooms = try? AppDelegate_ViewContext.fetch(fetchRequest)
        callback(rooms)
    }
    
}

extension RoomListViewModel{
    func deleteAllObjects(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try AppDelegate_ViewContext.execute(batchDeleteRequest)
        } catch let error {
            print("Error happened while deleting the records \(error.localizedDescription)")
        }
        
    }
}
