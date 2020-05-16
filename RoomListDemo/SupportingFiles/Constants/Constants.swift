//
//  Constants.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation
import UIKit

enum MyError: Error {
    case FoundNil(String)
}


//MARK: Others
//let KEY_WINDOW = UIApplication.shared.keyWindow //Sometimes it will not allow u to add any view on KeyWindow, where as APP_KEY_WINDOW will always allow u to do the same .
let APP_KEY_WINDOW = UIApplication.shared.delegate?.window
let APP_DELEGATE = AppDelegate.shared
//let DATA_MANAGER  = DataManager.shared()

let GET_REQUEST = "GET"
let POST_REQUEST = "POST"
let PUT_REQUEST = "PUT"
let DELETE_REQUEST = "DELETE"

let SUCCESS_CODE = 1


let LOADING_VIEW_TAG = 123456789
let LOADING_IMAGE_TAG = 987654321

let BACKEND_ERROR = 9000


//struct AlertType {
//    static let Default = 0
//    static let Confirmation = 1
//}

