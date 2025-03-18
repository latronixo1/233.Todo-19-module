//
//  ViewController.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 18.03.2025.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Подключить домашний интернет", "Купить шины", "Поменять диск на ноуте"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //регистрируем ячейку по умолчанию
        tableView.register(TodoCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //получаем ячейку по идентификатору
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //заполняем ячейку из массива
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK: - TableView Delegate
        
   
}
