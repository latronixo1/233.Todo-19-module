//
//  ViewController.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 18.03.2025.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            //загружаем массив Item из БД
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //регистрируем ячейку по умолчанию
        tableView.register(TodoCell.self, forCellReuseIdentifier: "ToDoCell")
        tableView.delegate = self

     }
    
    // MARK: - Tableview Datasource Methods
    
    //задаем количество ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //функция создания каждой ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //получаем ячейку по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            //заполняем ячейку из массива
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
       
        return cell
    }
    
    // MARK: - TableView Delegate
    
    //обработка события выбора ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //для удаления можно использовать:
//        context.delete(todoItems[indexPath.row])
//        todoItems.remove(at: indexPath.row)
        
//        //меняем значение done при клике на противоположное
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        //сохраняем данные
//        saveItems()
        
        //перезагрузить данные таблицы
        tableView.reloadData()
        
        //отмена окрашивания выбранной ячейки серым цветом
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //создаем модальное окно-предупреждение
        let alert = UIAlertController(title: "Добавить новую задачу", message: "", preferredStyle: .alert)
        
        //создаем для него кнопку
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
            //что должно произойти когда пользователь кликнет на кнопку "Добавить элемент" в UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.Items.append(newItem)   //так добавляется запись в отношение (связанное свойство) между таблицами
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
           }

            //перезагрузить таблицу
            self.tableView.reloadData()
        }
        
        //добавляем текстовое поле в это окно-предупреждение:
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Создайте новую задачу"
            textField = alertTextField
            
        }
        
        //добавляем эту кнопку в это окно-предупреждение
        alert.addAction(action)
        
        //отображаем окно-предупреждение
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    
//    func saveItems() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
    //}
    
    //функция загрузки имеет аргумент - принимает настроенную (с правилами фильтрации и сортировки) переменную request, у которого значение по умолчанию - загрузка всех (без фильтрации и сортировки) данных
    func loadItems() {
        
        todoItems = selectedCategory?.Items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        
//        if let additionslPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionslPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//        
//        do {
//            todoItems = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context /(error)")
//        }
//        //перезагрузить таблицу
    }

}

// MARK: - Search bar methods

//extension TodoListViewController: UISearchBarDelegate {
//    
//    //событие нажатия на кнопку поиска в searchBar
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        //создаем запрос на получение всех экземпляров Item из БД
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        
//        //настраиваем предикат (фильтр): поле title должно включать то, что написано в searchBar. [cd] - означает нечувствительность к регистру [c] и диакритике [d]
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        
//        //настраиваем сортировку по полю title - по алфавиту по возрастанию
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        //наполняем массив из БД
//        loadItems(with: request, predicate: predicate)
//               
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            
//            //для того чтобы клавиатура исчезла, нужно сделать так, чтобы текущий элемент больше не был первым ответчиком. Но делать мы это будем в отдельном потоке
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
