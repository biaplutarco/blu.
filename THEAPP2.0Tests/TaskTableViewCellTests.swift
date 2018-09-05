//
//  TaskTableViewCellTests.swift
//  THEAPP2.0Tests
//
//  Created by Ada 2018 on 04/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
import CoreData
@testable import THEAPP2_0

class TaskTableViewCellTests: XCTestCase {
    
    var cell: TaskTableViewCell?
    
    let dateFormatter = DateFormatter()
    
    var dbm: DBManager?
    
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
        
        let bundle = Bundle(for: self.classForCoder)
        let xib = bundle.loadNibNamed("TaskTableViewCell", owner: nil, options: nil)
        cell = xib?.first as? TaskTableViewCell
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dbm = DBManager(container: mockPersistantContainer)
        
    }
    
    override func tearDown() {
        cell = nil
        flushData()
        super.tearDown()
    }
    
    func test_checked() {
        
        let item = dbm?.insertItem(name: "item-1", initialDate: Date(timeIntervalSinceNow: -500), finalDate: Date(timeIntervalSinceNow: 500), category: .kitchen)
        cell?.item = item
        cell?.checked(cell?.checkBtn! as Any)
        XCTAssertEqual(cell?.checkBtn.tintColor, UIColor(named: "CheckColor"))
        cell?.checked(cell?.checkBtn! as Any)
        XCTAssertEqual(cell?.checkBtn.tintColor, UIColor.lightGray)
    }
    
    func test_timeDisplay() {
        let time1 = cell?.timeDisplay(forAmount: 1, onUnit: "week")
        let time2 = cell?.timeDisplay(forAmount: 2, onUnit: "week")
       
        XCTAssertEqual(time1, "1 week")
        XCTAssertEqual(time2, "2 weeks")
    }
    
    func test_timeDisplayForAmountOfDays() {
        let time1 = cell?.timeDisplay(forAmountOfDays: 1)
        let time2 = cell?.timeDisplay(forAmountOfDays: 21)
        let time3 = cell?.timeDisplay(forAmountOfDays: 39)
        let time4 = cell?.timeDisplay(forAmountOfDays: 380)
        
        XCTAssertEqual(time1, "1 day")
        XCTAssertEqual(time2, "3 weeks")
        XCTAssertEqual(time3, "1 month")
        XCTAssertEqual(time4, "1 year")
    }
    
    func test_setProgress_sameDay() {
        
        cell?.setProgress(initialDate: Date(), finalDate: Date())
        XCTAssertEqual(cell?.progressBar.progress, 0)
    }
    
    func test_setProgress_beforeStart() {
        
        let initialDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: Date())
        
        let finalDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 15, to: Date())
        
        cell?.setProgress(initialDate: initialDate!, finalDate: finalDate!)
        XCTAssertEqual(cell?.timeLeft.text, "Waiting to")
        XCTAssertEqual(cell?.labelLeft.text, "begin")
    }
    
    func test_setProgress_halfWay() {
 
        let initialDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -15, to: Date())
   
        let finalDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 15, to: Date())
        
        cell?.setProgress(initialDate: initialDate!, finalDate: finalDate!)
        XCTAssertEqual(cell?.progressBar.progress, 0.5)
        XCTAssertFalse((cell?.labelLeft.isHidden)!)
        XCTAssertFalse((cell?.timeLeft.isHidden)!)
        XCTAssertTrue((cell?.checkBtn.isHidden)!)
    }
    
    func test_setProgress_complete() {
        
        let initialDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -15, to: Date())
        
        cell?.setProgress(initialDate: initialDate!, finalDate: Date())
        XCTAssertEqual(cell?.progressBar.progress, 1)
        XCTAssertTrue((cell?.labelLeft.isHidden)!)
        XCTAssertTrue((cell?.timeLeft.isHidden)!)
        XCTAssertFalse((cell?.checkBtn.isHidden)!)
    }
}
