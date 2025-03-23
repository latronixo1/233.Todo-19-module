//
//  Data.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 23.03.2025.
//

import Foundation
import RealmSwift

//типичный класс для использования Realm
class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
