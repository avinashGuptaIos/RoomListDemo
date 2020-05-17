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
        START_LOADING_VIEW()
        if Utils.isInternetAvailable() {
            fetchRoomListFromServer { [weak self] (dataExists) in
                STOP_LOADING_VIEW()
                if dataExists
                {
                    self?.loadSavedRoomList { [weak self] (roomListx) in
                        if let roomList = roomListx , roomList.count > 0 {
                            self?.rooms.value = roomList
                        }
                    }
                }
            }
        }
        else
        {
            loadSavedRoomList { [weak self] (roomListx) in
                if let roomList = roomListx , roomList.count > 0 {
                    STOP_LOADING_VIEW()
                    self?.rooms.value = roomList
                }
            }
        }
    }
    

    
// DB Priority Flow
    
//    func getRoomList() {
//        START_LOADING_VIEW()
//        loadSavedRoomList { [weak self] (roomListx) in
//            if let roomList = roomListx , roomList.count > 0 {
//                STOP_LOADING_VIEW()
//                self?.rooms.value = roomList
//            }else
//            {
//                self?.fetchRoomListFromServer { [weak self] (dataExists) in
//                    if dataExists
//                    {
//                        STOP_LOADING_VIEW()
//                        self?.getRoomList()
//                    }
//                }
//            }
//        }
//    }
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
        DataManagerSharedInstance.saveRoomListToDb(roomList: roomList, callback: callback)
    }
    
    func loadSavedRoomList(callback:@escaping (_ roomList: [CDRoomData]?) -> Void){
        DataManagerSharedInstance.loadSavedRoomList(callback: callback)
    }
    
}
