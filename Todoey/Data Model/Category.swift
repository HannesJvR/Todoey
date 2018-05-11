//
//  Category.swift
//  Todoey
//
//  Created by Hannes Jansen van Rensburg on 2018/05/09.
//  Copyright © 2018 Hannes Jansen van Rensburg. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
//    let array1 = [1,2,3] //using type inference
//    let array2 = [Int]() //empty array of type Int
//    let array3 : [Int] = [1,2,3] //array of type Int with values
//    let array4 : Array<Int> = [1,2,3] //array of type Int with values
//    let array5 : Array<Int> //empty array of type Int
    
    
}
