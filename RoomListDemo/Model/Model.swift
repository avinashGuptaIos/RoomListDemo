//
//  Model.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

struct RoomList: Decodable {
    var data: [RoomData]?
    var success: Bool
}

struct RoomData: Decodable {
    var org: Org?
    var property: Property?
    var room: Room?
}

struct Org: Decodable {
    var id: Int?
    var name: String?
}

struct Property: Decodable {
    var id: Int?
    var name: String?
}

struct Room: Decodable {
    var id: Int?
    var name: String?
}

struct LockDetails: Decodable {
    var MAC: String?
    var name: String?
    var description: String?
    var success: Bool
}

