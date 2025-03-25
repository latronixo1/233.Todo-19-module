//
//  ViewController.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 18.03.2025.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()

    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            //загружаем массив Item из БД
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //регистрируем ячейку по умолчанию
        //tableView.register(TodoCell.self, forCellReuseIdentifier: "ToDoCell")
        tableView.delegate = self
        
        //убираем разделители между ячейками
        tableView.separatorStyle = .none
     }
    
    //перед появлением экрана окрасим navigationBar в цвет выбранной категории
    override func viewWillAppear(_ animated: Bool) {
        //извлекаем строку с текстом из БД (в БД нельзя хранить цвет, поэтому храним в формате String)
        if let colorHex = selectedCategory?.rowColor {
            
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist") }
            
            //получаем цвет путем преобразования из строки, содержащей hex
            if let navBarColor = UIColor(hexString: colorHex) {
                
                //Для новых версий ios (>15), чтобы цвет навбара не перекрывался
                if #available(iOS 15.0, *) {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = navBarColor
                    
                    // Устанавливаем цвет заголовка (стандартный и большой)
                    appearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                    appearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                    
                    navBar.standardAppearance = appearance
                    navBar.scrollEdgeAppearance = appearance
                } else {    //а теперь для старых (<15) версий
                    navBar.backgroundColor = navBarColor    //у Анжелы это barTintColor (так было в предыдущих версиях iOS)
                    navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
//                    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                    
                    navBar.titleTextAttributes = [.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                    navBar.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                }
                
                //Меняем цвета searchBar'a
                if let searchBar = searchBar {
                    // Убираем стандартный фон и рамку
                    searchBar.backgroundImage = UIImage() // Прозрачный фон
                    searchBar.backgroundColor = navBarColor
                    searchBar.barTintColor = .clear      // Прозрачный бар
                    
                    // Настраиваем текстовое поле
                    let searchTextField = searchBar.searchTextField
                    searchTextField.backgroundColor = .white // Белый фон поля ввода
                    searchTextField.borderStyle = .none      // Убираем стандартную рамку
                    
                    // Кастомная рамка
                    searchTextField.layer.borderWidth = 1.0
                    searchTextField.layer.borderColor = navBarColor.cgColor
                    searchTextField.layer.cornerRadius = 10.0 // Закругление углов
                    searchTextField.layer.masksToBounds = true
                    
                    // тень вокруг рамки
                    searchTextField.layer.shadowColor = navBarColor.cgColor
                    searchTextField.layer.shadowOpacity = 0.7
                    searchTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
                    searchTextField.layer.shadowRadius = 4
                    
                    //Цвет иконки
                    searchTextField.leftView?.tintColor = navBarColor
                }
            }
        }
    }
    
    // MARK: - Tableview Datasource Methods
    
    //задаем количество ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //функция создания каждой ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            //заполняем ячейку из массива
            cell.textLabel?.text = item.title
            
            //Меняем цвет ячеек в цвет выбранной категории от светлого оттенка до темного
            if let color = UIColor(hexString: selectedCategory!.rowColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                //а цвет текста наоборот - при светлом фоне он черный, а когда фон темнеет - он белеет
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            //галку ставим, если задача выполнена, и наоборот
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
       
        return cell
    }
    
    // MARK: - TableView Delegate
    
    //обработка события выбора ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        //для удаления можно использовать:
//        context.delete(todoItems[indexPath.row])
//        todoItems.remove(at: indexPath.row)
        
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
                        newItem.dateCreated = Date()
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
    
    //функция загрузки имеет аргумент - принимает настроенную (с правилами фильтрации и сортировки) переменную request, у которого значение по умолчанию - загрузка всех (без фильтрации и сортировки) данных
    func loadItems() {
        
        todoItems = selectedCategory?.Items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }
    
    // MARK: - Delete Data From Swipe
    
    //событие удаления ячейки
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }

}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    //событие нажатия на кнопку поиска в searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //фильтруем по тексту в searchBar, сортируем по алфавиту
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //для того чтобы клавиатура исчезла, нужно сделать так, чтобы текущий элемент больше не был первым ответчиком. Но делать мы это будем в отдельном потоке
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
