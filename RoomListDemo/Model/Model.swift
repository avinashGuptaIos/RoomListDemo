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

struct RoomData: Codable {
    var org: Org?
    var property: Property?
    var room: Room?
}

struct Org: Codable {
    var id: Int?
    var name: String?
}

struct Property: Codable {
    var id: Int?
    var name: String?
}

struct Room: Codable {
    var id: Int?
    var name: String?
}

struct LockDetails: Codable {
    var MAC: String?
    var name: String?
    var description: String?
}

