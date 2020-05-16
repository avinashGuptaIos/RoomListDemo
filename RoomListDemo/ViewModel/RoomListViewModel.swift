//
//  RoomListViewModel.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

typealias DataExists = (_ dataIsThere: Bool) -> Void

class RoomListViewModel {
    func getRoomList() {
        loadSavedRoomList { [weak self] (roomListx) in
            if let roomList = roomListx , roomList.count > 0 {
//                self?.repos = reposList
            }else
            {
                self?.fetchRoomListFromServer { [weak self] (dataExists) in
                    if dataExists
                    {
//                        self?.getRoomList()
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
                let roomList = try? JSONDecoder().decode(RoomList.self, from: roomListData)
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
                self.deleteAllObjects(entityName: "CDRepo")
            }
            print("Rooms data are ",roomList)
//            for room in roomList{
//                let cdRepo = CDRepo(context: self.viewContext)
//                cdRepo.nodeId = repo.nodeId
//                cdRepo.name = repo.name
//                cdRepo.fullName = repo.full_name
//                cdRepo.detailDescription = repo.detailDescription
//            }
//            AppDelegate.shared.saveContext()
//            callback(repos.count > 0)
            callback(true)
        }
    }
       
       func loadSavedRoomList(callback:@escaping (_ roomList: [RoomData]?) -> Void){
//           let fetchRequest =  NSFetchRequest<CDRepo>(entityName: "CDRepo")
//           let repos = try? viewContext.fetch(fetchRequest)
//           callback(repos)
        callback(nil)
       }
    
    func deleteAllObjects(entityName: String) {
//          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//          let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//          do {
//              try viewContext.execute(batchDeleteRequest)
//          } catch let error {
//              print("Error happened while deleting the records \(error.localizedDescription)")
//          }
          
      }
}
