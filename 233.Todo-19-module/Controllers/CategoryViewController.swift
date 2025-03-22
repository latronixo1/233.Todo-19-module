//
//  CategoryViewController.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 22.03.2025.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()

    //константа, которую мы будем использовать в качестве посредника для взаимодействия с базой данных
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        //регистрируем ячейку по умолчанию
        tableView.register(TodoCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self

        //загружаем массив Item из БД
        loadItems()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    // MARK: - TableView Datasource Methods
    
    
    
    // MARK: - TableView Delegate Methods
    
    
    
    // MARK: - Data Manipulation Methods
    
    //функция загрузки имеет аргумент - принимает настроенную (с правилами фильтрации и сортировки) переменную request, у которого значение по умолчанию - загрузка всех (без фильтрации и сортировки) данных
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context /(error)")
        }
        //перезагрузить таблицу
        tableView.reloadData()
    }

    
    
}
