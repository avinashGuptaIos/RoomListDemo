//
//  Apis.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

//MARK: Singletons
class CustomDate {
   private var date: Date?
    init() { date = Date() }
    
    func currentTimeStamp() -> String {
        return "\(Int(date?.timeIntervalSince1970 ?? 0.0))"
    }
}

let Shared_CustomJsonEncoder = CustomJsonEncoder.shared.getSharedEncoder()
class CustomJsonEncoder {
   private var jsonEncoder: JSONEncoder
    private init(){ jsonEncoder = JSONEncoder() }
    static let shared = CustomJsonEncoder()
    
    func getSharedEncoder() -> JSONEncoder {
        return jsonEncoder
    }
}

let Shared_CustomJsonDecoder = CustomJsonDecoder.shared.getSharedDecoder()
class CustomJsonDecoder {
   private var jsonDecoder: JSONDecoder
    private init(){ jsonDecoder = JSONDecoder() }
    static let shared = CustomJsonDecoder()
    
    func getSharedDecoder() -> JSONDecoder {
        return jsonDecoder
    }
}

//MARK:- App APIS
let AppDelegate_ViewContext = AppDelegate.shared.persistentContainer.viewContext

let BASE_URL = "https://api.snglty.com/"

func GET_ROOM_LIST() -> String {
    "v1/test/roomsList?timestamp=\(getCurrentTimeStamp())"
}

func GET_LOCK_DETAILS(roomId: String) -> String {
    "v1/test/lockDetails?roomId=\(roomId)&timestamp=\(getCurrentTimeStamp())" 
}

func getCurrentTimeStamp() -> String{
    return CustomDate().currentTimeStamp()
}

func START_LOADING_VIEW()  {
    if Utils.isInternetAvailable() {
        DispatchQueue.main.async {
            let loadingView = LoadingView()
            loadingView.tag = LOADING_VIEW_TAG
            APP_KEY_WINDOW?.addSubview(loadingView)
            loadingView.startAnimation()
        }
    }
    else
    {
        STOP_LOADING_VIEW()
    }
}

func STOP_LOADING_VIEW()  {
    DispatchQueue.main.async {
        let loadingView = APP_KEY_WINDOW?.viewWithTag(LOADING_VIEW_TAG) as? LoadingView
        loadingView?.stopAnimation()
    }
}
