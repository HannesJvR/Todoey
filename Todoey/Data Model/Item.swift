//
//  Item.swift
//  Todoey
//
//  Created by Hannes Jansen van Rensburg on 2018/05/09.
//  Copyright © 2018 Hannes Jansen van Rensburg. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    //Category - refers to an class
    //Category.self - refers to an instance
    //"items" - refers to forward relationship
}
