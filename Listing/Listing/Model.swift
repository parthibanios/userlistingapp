//
//  Model.swift
//  AddressList
//
//  Created by PARTHIBAN on 21/01/19.
//  Copyright © 2019 PARTHIBAN. All rights reserved.
//

import UIKit

struct userList: Codable {
    var data: [userDetail]?
}
struct userDetail: Codable {
    var first_name : String?
    var last_name : String?
    var avatar : String?
}
