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
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "categoryCell")
        tableView.delegate = self

        //загружаем массив Category из БД
        loadCategories()
    }

    
    // MARK: - TableView Datasource Methods
    
    //задаем количество ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //функция создания каждой ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //получаем ячейку по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        //заполняем ячейку из массива
        cell.textLabel?.text = category.name
        
        //cell.accessoryType = category.done ? .checkmark : .none
       
        return cell
    }
    
    // MARK: - TableView Delegate
    
    //обработка события выбора ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //для удаления можно использовать:
//        context.delete(categoryArray[indexPath.row])
//        categoryArray.remove(at: indexPath.row)
        
        //меняем значение done при клике на противоположное
        //categoryArray[indexPath.row].done = !categoryArray[indexPath.row].done
        
        let todoVC = TodoListViewController()
        self.navigationController?.pushViewController(todoVC, animated: true)
        
        //сохраняем данные
        //saveCategories()
        
        //перезагрузить данные таблицы
        tableView.reloadData()
        
        //отмена окрашивания выбранной ячейки серым цветом
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        print("add button pressed")
    }
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //создаем модальное окно-предупреждение
        let alert = UIAlertController(title: "Добавить новую категорию", message: "", preferredStyle: .alert)
        
        //создаем для него кнопку
        let action = UIAlertAction(title: "Добавить ", style: .default) { (action) in
            //что должно произойти когда пользователь кликнет на кнопку "Добавить элемент" в UIAlert
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            //добавить новый элемент в массив
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
            //перезагрузить таблицу
            self.tableView.reloadData()
        }
        
        //добавляем текстовое поле в это окно-предупреждение:
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Создайте новую категорию"
            textField = alertTextField
            
        }
        
        //добавляем эту кнопку в это окно-предупреждение
        alert.addAction(action)
        
        //отображаем окно-предупреждение
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    //функция загрузки имеет аргумент - принимает настроенную (с правилами фильтрации и сортировки) переменную request, у которого значение по умолчанию - загрузка всех (без фильтрации и сортировки) данных
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context /(error)")
        }
        //перезагрузить таблицу
        tableView.reloadData()
    }

    
    
}
