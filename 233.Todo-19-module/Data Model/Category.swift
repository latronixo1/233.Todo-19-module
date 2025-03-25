//
//  Category.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 24.03.2025.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var rowColor: String = ""
    let Items = List<Item>()    //отношение Items - к классу (таблице в БД) Item.
}
