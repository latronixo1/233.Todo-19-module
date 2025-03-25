//
//  SwipeTableViewController.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 25.03.2025.
//

import UIKit
import SwipeCellKit

//суперкласс, благодаря которому можно сократить количество кода, если в нашем приложении нужно реализовать возможность свайпа более чем в одной таблице
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80

     }
    
    //создание ячейки. Здесь собраны только общие для всех дочерних таблиц действия
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //получаем ячейку по идентификатору как ячейку с реализованной функцией свайпа
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        //ее делегатом назначаем себя
        cell.delegate = self

        return cell
    }

    //Обработка события короткого свайпа влево
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        //обработка события удаления (что мы будем удалять и как?)
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
        }

        // картинка для кнопки, которая появится справа при свайпе влево
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    //Обработка события длинного свайпа влево (удаление ячейки)
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }

    //эта функция будет переопределяться в дочерних классах. Здесь будет непосредственно описано удаление ячейки
    func updateModel (at indexPath: IndexPath) {
        
    }
    
}
