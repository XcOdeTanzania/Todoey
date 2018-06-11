//
//  Item.swift
//  Todoey
//
//  Created by Qlicue on 09/06/2018.
//  Copyright © 2018 transevents. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title:String = ""
    @objc dynamic  var done:Bool = false
    @objc dynamic var createdAt: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
