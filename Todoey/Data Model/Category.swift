//
//  Category.swift
//  Todoey
//
//  Created by Qlicue on 09/06/2018.
//  Copyright © 2018 transevents. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
