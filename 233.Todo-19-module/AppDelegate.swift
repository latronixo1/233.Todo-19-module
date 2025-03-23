//
//  AppDelegate.swift
//  233.Todo-19-module
//
//  Created by Валентин Картошкин on 18.03.2025.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        let data = Data()
        data.name = "Valentin"
        data.age = 38
        
        do {
            //инициализируем Realm
            let config = Realm.Configuration.defaultConfiguration
            let realm = try Realm(configuration: config)
//            try realm.write {
//                realm.add(data)
            //}
        } catch {
            print("Error initialising new realm, \(error)")
        }
 
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Вызывается при создании сеанса создания новой сцены.
        // Используйте этот метод, чтобы выбрать конфигурацию для создания новой сцены.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    //переменная - база данных SQLite
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         Постоянный контейнер для приложения. Эта реализация
                  создает и возвращает контейнер, загрузив в него хранилище для
         приложения. Это свойство необязательно, поскольку существуют допустимые
          ошибки, которые могут привести к сбою при создании хранилища.
         */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Замените эту реализацию кодом для соответствующей обработки ошибки.
                // // фатальная ошибка() приводит к тому, что приложение генерирует журнал сбоев и завершает работу. Вам не следует использовать эту функцию в приложении доставки, хотя она может быть полезна при разработке.
                 
                /*
                 Типичные причины возникновения ошибки здесь включают:
                 * Родительский каталог не существует, его невозможно создать или он запрещает запись.
                 * Постоянное хранилище недоступно из-за разрешений или защиты данных, когда устройство заблокировано.
                 * На устройстве недостаточно места.
                 * Не удалось перенести хранилище на текущую версию модели.
                 Проверьте сообщение об ошибке, чтобы определить, в чем именно заключалась проблема.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Замените эту реализацию кодом для соответствующей обработки ошибки.
                // // фатальная ошибка() приводит к тому, что приложение генерирует журнал сбоев и завершает работу. Вам не следует использовать эту функцию в приложении доставки, хотя она может быть полезна при разработке.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }}

