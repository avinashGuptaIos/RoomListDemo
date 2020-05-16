//
//  Apis.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

class CustomDate {
    var date: Date?
    private init() { date = Date() }
    static let shared = CustomDate()
    
    func currentTimeStamp() -> String {
        return "\(Int(date?.timeIntervalSince1970 ?? 0.0))"
    }
}

//MARK:- App APIS

let BASE_URL = "https://api.snglty.com/"

func GET_ROOM_LIST() -> String {
    "v1/test/roomsList?timestamp=\(getCurrentTimeStamp())" //Need to implement the Timestamp
}

func GET_LOCK_DETAILS(roomId: String) -> String {
    "v1/test/lockDetails?roomId=\(roomId)&timestamp=\(getCurrentTimeStamp())" //Need to implement the Timestamp
}

func getCurrentTimeStamp() -> String{
    return CustomDate.shared.currentTimeStamp()
}

func START_LOADING_VIEW()  {
    if Utils.isInternetAvailable() {
        DispatchQueue.main.async {
            let loadingView = LoadingView()
            loadingView.tag = LOADING_VIEW_TAG
            APP_KEY_WINDOW??.addSubview(loadingView)
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
        let loadingView = APP_KEY_WINDOW??.viewWithTag(LOADING_VIEW_TAG) as? LoadingView
        loadingView?.stopAnimation()
    }
}
