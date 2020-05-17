//
//  Globals.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation
import UIKit

//MARK: ShowLoader
func SHOW_LOADER()
{
    if Utils.isInternetAvailable() {
        START_LOADING_VIEW()
    }
    else
    {
        STOP_LOADING_VIEW()
    }
}

func SHOW_TOAST(_ msg: String?) {
    if let message = msg {
        DispatchQueue.main.async {
            APP_KEY_WINDOW?.makeToast(message)
        }
    }
}

func PRINT_LOG(_ msg: Any?) {
    if let message = msg {
        print("Something happened \(message)")
    }
}

//MARK: Extention for Notification.Name

extension Notification.Name {
    public static let INTERNET_CONNECTION = Notification.Name(rawValue: "InternetConnection")
}

//MARK: Extention for Array

extension Array {
    func indexesOf<T : Equatable>(object:T) -> [Int] {
        var result: [Int] = []
        for (index,obj) in self.enumerated() {
            if obj as! T == object {
                result.append(index)
            }
        }
        return result
    }
}
