//
//  AddItemViewControllerTests.swift
//  THEAPP2.0Tests
//
//  Created by Ada 2018 on 04/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
import CoreData
@testable import THEAPP2_0

class AddItemViewControllerTests: XCTestCase {
    
    var viewController: AddItemViewController!
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
        dbm = DBManager(container: mockPersistantContainer)
        let storyboard = UIStoryboard(name: "AddItem", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "addItem") as! AddItemViewController
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        flushData()
        super.tearDown()
    }
    
    func test_viewDidLoad_withItem() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm"
        let initialDate = formatter.date(from: "11/04/2015 09:35")!
        let item = dbm?.insertItem(name: "Test", initialDate: initialDate.removeTime(), finalDate: initialDate.addDays(days: 60), category: .bathroom)
        item?.taskType = TaskType.clean.rawValue
        viewController.item = item
        viewController.viewDidLoad()
        XCTAssertEqual(viewController.nameTextField.text, "Test")
        XCTAssertEqual(viewController.timeFrameTextField.text, "2 Months")
        XCTAssertEqual(viewController.initialDateTextField.text, "11/04/2015")
        XCTAssertEqual(viewController.notificationTimeTextField.text, "09:35")
        XCTAssertEqual(viewController.taskSegmentedControl.selectedSegmentIndex, 2)
    }
    
    func test_valueChanged() {
        let types: [TaskType] = [TaskType.change, TaskType.throwAway, TaskType.clean]
        for (index, task) in types.enumerated() {
            viewController.taskSegmentedControl.changeSelectedIndex(to: index)
            viewController.valueChanged(viewController.taskSegmentedControl)
            XCTAssertEqual(viewController.taskType, task)
        }
    }
    
    func test_timeFrame() {
        viewController.timeValue = 1
        
        let results: [TimeFrame] = [TimeFrame.day, TimeFrame.week, TimeFrame.month, TimeFrame.year]
        
        for (index, value) in results.enumerated() {
            viewController.timeUnitInput = index
            XCTAssertEqual(viewController.timeFrame, Double(value.rawValue))
        }
        
    }
    
    func test_date_toString() {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 09
        dateComponents.day = 04
        
        let date = Calendar.current.date(from: dateComponents)
        
        let string = date?.toString(format: "dd/MM/yyyy")
        
        XCTAssertEqual(string, "04/09/2018")
    }
    
    func test_date_removeTime() {
        let date = Date()
        print(date)
        date.removeTime()
        print(date)
    }
    
    
}
