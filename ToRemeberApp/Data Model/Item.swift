//
//  Item.swift
//  ToRemeberApp
//
//  Created by Amna Amna on 7/10/20.
//  Copyright © 2020 Amna Amna. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var itemName : String = ""
    @objc dynamic var isDone : Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
      
}
