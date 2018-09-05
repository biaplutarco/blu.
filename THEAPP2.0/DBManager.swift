//
//  DBManager.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CoreData

class DBManager {
    
    static let shared = DBManager()
    
    let persistentContainer: NSPersistentContainer!
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func save() throws {
        try persistentContainer.viewContext.save()
    }
    
    func delete(item: Item) {
        persistentContainer.viewContext.delete(item)
        try! save()
    }
    
    @discardableResult
    func insertItem(name: String, initialDate: Date, finalDate: Date, category: HouseCategory) -> Item? {
        let object = NSEntityDescription.insertNewObject(forEntityName: "Item", into: persistentContainer.viewContext) as! Item
        object.name = name
        object.initialDate = initialDate
        object.finalDate = finalDate
        object.category = category.rawValue
        object.isDone = false
        do {
            try save()
            return object
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func refreshItem(item: Item) -> Bool {
        guard let initialDate = item.initialDate,
            let finalDate = item.finalDate else {
            return false
        }
        let timeFrame = finalDate.timeIntervalSince(initialDate)
        item.initialDate = Date()
        item.finalDate = item.initialDate?.addingTimeInterval(timeFrame)
        item.isDone = false
        do {
            try save()
            return true
        } catch {
            return false
        }
    }
    
    func fetchAllItens() -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results!
    }
    
    func fetchItensExpiringToday() -> [Item] {
        let all = fetchAllItens()
        let today = Calendar.current.date(bySettingHour: 0, minute: 00, second: 0, of: Date())!
        return filterSameDay(itens: all, date: today)
    }
    
    func fetchItensExpiringThisWeek() -> [Item] {
        let all = fetchAllItens()
        let today = Calendar.current.date(bySettingHour: 0, minute: 00, second: 0, of: Date())!
        return filterSameWeek(itens: all, date: today)
    }
    
    func fetchItensExpiringThisMonth() -> [Item] {
        let all = fetchAllItens()
        let today = Calendar.current.date(bySettingHour: 0, minute: 00, second: 0, of: Date())!
        return filterSameMonth(itens: all, date: today)
    }
    
    func fetchItensExpiringAfterThisMonth() -> [Item] {
        let all = fetchAllItens()
        let today = Calendar.current.date(bySettingHour: 0, minute: 00, second: 0, of: Date())!
        return filterAfter(itens: all, date: today)
    }
    
    func filterSameDay(itens: [Item], date: Date) -> [Item] {
        
        
        return itens.filter { (item) -> Bool in
            
            let components = Calendar.current.dateComponents([.day], from: date, to: item.finalDate!)
            
            let days = components.day
            
            if days! <= 0 {
                return true
            }
            return false
        }
        
    }
    
    func filterSameWeek(itens: [Item], date: Date) -> [Item] {

        return itens.filter { (item) -> Bool in
                
                let components = Calendar.current.dateComponents([.day], from: date, to: item.finalDate!)
                
                let days = components.day
                
                if days! > 0 && days! <= 7 {
                    return true
                }
                return false
            }
        
    }
    
    func filterSameMonth(itens: [Item], date: Date) -> [Item] {
        
        return itens.filter { (item) -> Bool in
            
            let components = Calendar.current.dateComponents([.day], from: date, to: item.finalDate!)
            
            let days = components.day
            
            if days! > 7 && days! <= 30 {
                return true
            }
            return false
        }
    }
    
    func filterAfter(itens: [Item], date: Date) -> [Item] {
        
        return itens.filter { (item) -> Bool in
            
            let components = Calendar.current.dateComponents([.day], from: date, to: item.finalDate!)
            
            let days = components.day
            
            if days! > 30 {
                return true
            }
            return false
        }
    }
    
    
    func countItens(ofType type:HouseCategory) -> Int {
        let items = fetchAllItens()
        return (items.filter { item in
            return item.category == type.rawValue
        }).count
    }
    
}
