//
//  SwipeTableViewController.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 25.03.2025.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

     }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //получаем ячейку по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self

        return cell
    }

    //Обработка события короткого свайпа влево
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        //обработка события удаления (что мы будем удалять и как?)
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            print("Delete cell")
            
            self.updateModel(at: indexPath)
            
        }

        // картинка для кнопки, которая появится справа при свайпе влево
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    //Обработка события длинного свайпа влево (
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }

    func updateModel (at indexPath: IndexPath) {
        
    }
    
}
