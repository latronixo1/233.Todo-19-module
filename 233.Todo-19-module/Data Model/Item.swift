//
//  Item.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 20.03.2025.
//

import Foundation

//соответствие протоколу Encodable означает, что его экземпляры можно кодировать в формате файлов plist (и не только)
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
