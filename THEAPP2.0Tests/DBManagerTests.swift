//
//  DBManagerTests.swift
//  THEAPP2.0Tests
//
//  Created by Ada 2018 on 03/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
import CoreData

@testable import THEAPP2_0

class DBManagerTests: XCTestCase {
    
    var dbm: DBManager?
    
    let dateFormatter = DateFormatter()
    let today = Calendar.current.date(bySettingHour: 0, minute: 00, second: 0, of: Date())!
    
    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataUnitTesting", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("In memory coordinator creation failed \(error)")
            }
        }
        return container
    }()
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }
    
    override func setUp() {
        super.setUp()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dbm = DBManager(container: mockPersistantContainer)
    }
    
    override func tearDown() {
        flushData()
        super.tearDown()
    }
    
    func test_fetchAll_empty() {
        
        let items = dbm?.fetchAllItens()
        
        XCTAssertEqual(items?.count, 0)
    }
    
    func test_fetchAll() {
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-07-30")!, finalDate: dateFormatter.date(from: "2018-09-03")!, category: .bedroom)
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-07-30")!, finalDate: dateFormatter.date(from: "2018-09-03")!, category: .bedroom)
        
        let items = dbm?.fetchAllItens()
        
        XCTAssertEqual(items?.count, 2)
    }
    
    func test_delete() {
        let item =  dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-07-30")!, finalDate: dateFormatter.date(from: "2018-09-03")!, category: .bedroom)
        
        dbm?.delete(item: item!)
        
        let items = dbm?.fetchAllItens()
        
        XCTAssertEqual(items?.count, 0)
    }
    
    func test_refreshItem() {
        let item =  dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-09-04")!, finalDate: dateFormatter.date(from: "2018-10-04")!, category: .bedroom)
        
        dbm?.refreshItem(item: item!)
        
        var components = Calendar.current.dateComponents([.day], from: (item?.initialDate)!, to: today)
        var days = components.day
        XCTAssertEqual(days, 0)
        
        components = Calendar.current.dateComponents([.day], from: (item?.finalDate)!, to: today.addDays(days: 30))
        days = components.day
        XCTAssertEqual(days, 0)
    }
    
    func test_fetchItensExpiringToday() {
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-08-04")!, finalDate: Date(), category: .bedroom)
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-08-04")!, finalDate: today.addDays(days: 1), category: .bedroom)
        
        let itemsExpiringToday = dbm?.fetchItensExpiringToday()
        
        XCTAssertEqual(itemsExpiringToday?.count, 1)
    }
    
    func test_fetchItensExpiringThisWeek() {
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-08-04")!, finalDate: today.addDays(days: 7), category: .bedroom)
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-08-04")!, finalDate: today.addDays(days: 9), category: .bedroom)
        
        let itemsExpiringThisWeek = dbm?.fetchItensExpiringThisWeek()
        
        XCTAssertEqual(itemsExpiringThisWeek?.count, 1)
    }
    
    func test_fetchItensExpiringThisMonth() {
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-08-04")!, finalDate: today.addDays(days: 30), category: .bedroom)
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-08-04")!, finalDate: today.addDays(days: 34), category: .bedroom)
        
        let itemsExpiringThisMonth = dbm?.fetchItensExpiringThisMonth()
        
        XCTAssertEqual(itemsExpiringThisMonth?.count, 1)
    }
    
    func test_fetchItensExpiringAfterThisMonth() {
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-08-04")!, finalDate: today.addDays(days: 45), category: .bedroom)
        dbm?.insertItem(name: "test 1", initialDate: dateFormatter.date(from: "2018-08-04")!, finalDate: today.addDays(days: 23), category: .bedroom)
        
        let itemsExpiringAfterThisMonth = dbm?.fetchItensExpiringAfterThisMonth()
        
        XCTAssertEqual(itemsExpiringAfterThisMonth?.count, 1)
    }
    
    func test_itemDescription() {
        let initialDate = dateFormatter.date(from: "2018-08-04") as! Date
        let itemA = dbm?.insertItem(name: "test 1", initialDate: initialDate, finalDate: initialDate.addDays(days: 30), category: .bedroom)
        XCTAssertEqual(itemA?.description, "test 1-Bedroom-2018-08-04 03:00:00 +0000-2018-09-03 03:00:00 +0000")
        itemA?.name = nil
        itemA?.category = nil
        itemA?.initialDate = nil
        itemA?.finalDate = nil
        XCTAssertEqual(itemA?.description, "")
    }
}

extension Date {
    func addDays(days: Int) -> Date {
        return Calendar.current.date(byAdding: Calendar.Component.day, value: days, to: self)!
    }
}
