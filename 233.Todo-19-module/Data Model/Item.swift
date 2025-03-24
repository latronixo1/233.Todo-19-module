//
//  Item.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 24.03.2025.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "Items") //отношение один ко многим к таблице Category
    }
