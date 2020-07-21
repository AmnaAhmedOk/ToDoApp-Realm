//
//  Category.swift
//  ToRemeberApp
//
//  Created by Amna Amna on 7/10/20.
//  Copyright © 2020 Amna Amna. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
