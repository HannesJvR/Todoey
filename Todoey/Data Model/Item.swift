//
//  Item.swift
//  Todoey
//
//  Created by Hannes Jansen van Rensburg on 2018/05/08.
//  Copyright © 2018 Hannes Jansen van Rensburg. All rights reserved.
//

import Foundation

class Item: Codable { //To be Codable all properties need to use standard data types (no custom classes) - Codable means Encodable + Decodable
    var title : String = ""
    var done : Bool = false
}
