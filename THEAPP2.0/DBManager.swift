//
//  DBManager.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CoreData

class DBManager: NSObject {
    static private func fetch(from: Date, to: Date) -> [Item] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        do {
            let results: [Item] = try AppDelegate.persistentContainer.viewContext.fetch(request) as! [Item]
            return results.filter { (item) -> Bool in
                if let date = item.finalDate {
                    return date > from && date < to
                }
                return false
            }
        } catch {
            return []
        }
    }
    
    static func refreshItem(item: Item) -> Bool {
        guard let initialDate = item.initialDate,
            let finalDate = item.finalDate else {
            return false
        }
        let timeFrame = finalDate.timeIntervalSince(initialDate)
        item.initialDate = finalDate
        item.finalDate = item.finalDate?.addingTimeInterval(timeFrame)
        item.isDone = false
        do {
            try DBManager.save()
            return true
        } catch {
            return false
        }
    }
    
    static func save() throws {
        try AppDelegate.persistentContainer.viewContext.save()
    }
    
    static func delete(item: Item) {
        AppDelegate.persistentContainer.viewContext.delete(item)
    }
    
    static func insertItem(name: String, initialDate: Date, finalDate: Date, category: HouseCategory) -> Bool {
        let object = NSEntityDescription.insertNewObject(forEntityName: "Item", into: AppDelegate.persistentContainer.viewContext) as! Item
        object.name = name
        object.initialDate = initialDate
        object.finalDate = finalDate
        object.category = category.rawValue
        object.isDone = false
        do {
            try DBManager.save()
            return true
        } catch {
            return false
        }
    }
    
    static func fetchAllItens() -> [Item] {
        return fetch(from: Date.distantPast, to: Date.distantFuture)
    }
    
    static func fetchItensExpiringToday() -> [Item] {
        let all = fetch(from: Date.distantPast, to: Date.distantFuture)
        return filterSameDay(itens: all, date: Date())
//        return fetch(from: Date(timeIntervalSinceNow: -86400), to: Date.init(timeIntervalSinceNow: 0))
    }
    
    static func fetchItensExpiringThisWeek() -> [Item] {
        let all = fetch(from: Date.distantPast, to: Date.distantFuture)
        return filterSameWeek(itens: all, date: Date())
//        return fetch(from: Date(timeIntervalSinceNow: -604800), to: Date(timeIntervalSinceNow: -86400))
    }
    
    static func fetchItensExpiringThisMonth() -> [Item] {
        let all = fetch(from: Date.distantPast, to: Date.distantFuture)
        return filterSameMonth(itens: all, date: Date())
//        return fetch(from: Date(timeIntervalSinceNow: -2592000), to: Date(timeIntervalSinceNow: -604800))
    }
    
    static func fetchItensExpiringAfterThisMonth() -> [Item] {
        let all = fetch(from: Date.distantPast, to: Date.distantFuture)
        return filterAfter(itens: all, date: Date())
//        return fetch(from: Date.distantPast, to: Date(timeIntervalSinceNow: -2592000))
    }
    
    static func filterSameDay(itens: [Item], date: Date) -> [Item] {
        
        return itens.filter { (item) -> Bool in
            
            let components = Calendar.current.dateComponents([.day], from: date, to: item.finalDate!)
            
            let days = components.day
            
            if days! == 0 {
                return true
            }
            return false
        }
        
    }
    
    static func filterSameWeek(itens: [Item], date: Date) -> [Item] {

            return itens.filter { (item) -> Bool in
                
                let components = Calendar.current.dateComponents([.day], from: date, to: item.finalDate!)
                
                let days = components.day
                
                if days! > 0 && days! <= 7 {
                    return true
                }
                return false
            }
        
    }
    
    static func filterSameMonth(itens: [Item], date: Date) -> [Item] {
        
        return itens.filter { (item) -> Bool in
            
            let components = Calendar.current.dateComponents([.day], from: date, to: item.finalDate!)
            
            let days = components.day
            
            if days! > 7 && days! <= 30 {
                return true
            }
            return false
        }
    }
    
    static func filterAfter(itens: [Item], date: Date) -> [Item] {
        
        return itens.filter { (item) -> Bool in
            
            let components = Calendar.current.dateComponents([.day], from: date, to: item.finalDate!)
            
            let days = components.day
            
            if days! > 30 {
                return true
            }
            return false
        }
    }
    
}
