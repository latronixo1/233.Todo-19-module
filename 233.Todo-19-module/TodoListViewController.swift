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
        tableView.delegate = self
    }

    // MARK: - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //получаем ячейку по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoCell
        
        //заполняем ячейку из массива
        cell.textLabel?.text = itemArray[indexPath.row]
        //cell.delegate = self
        return cell
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Выбрана задача \(itemArray[indexPath.row])")
        
//        tableView.cellForRow(at: indexPath)?.accessoryType = .disclosureIndicator
//        tableView.cellForRow(at: indexPath)?.accessoryType = .detailDisclosureButton
        // ставим галку при выборе и снимаем ее при повторном выборе
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //отмена окрашивания выбранной ячейки серым цветом
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}
