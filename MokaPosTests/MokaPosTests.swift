//
//  MokaPosTests.swift
//  MokaPosTests
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import XCTest
import CoreData

@testable import MokaPos

class MokaPosTests: XCTestCase {
    
    var coreDataStack: CoreDataTestStack!
    
    //Convinient function for notification
    var saveNotificationCompleteHandler: ((Notification)->())?
    
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        //Listen to the change in context
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave , object: nil)
        initStubs()
    }

    
    override func tearDown() {
        NotificationCenter.default.removeObserver(self)
        flushData()
        super.tearDown()
    }
    
    
    func testCreateItem() {
        //Given the name & status
        let id = 11
        let title = "Item 11"
        
        //When add item
        let item = insertItem(id: id, title: title)
        
        //Assert: return item
        XCTAssertNotNil(item)
    }
    
    
    func testFetchAllItems() {
        //When fetch
        let items = fetchAll().count
        
        //Assert return two items
        XCTAssertEqual(items, 5)
    }
    
    
    func testRemoveItem() {
        //Given a item in persistent store
        let items = fetchAll()
        let item = items[0]
        
        let numberOfItems = items.count
        
        //When remove a item
        remove(objectID: item.objectID)
        save()
        
        //Assert number of item - 1
        XCTAssertEqual(fetchAll().count, numberOfItems-1)
        
    }
    
    
    func testSave() {
        //Give an item
        let id = 10
        let title = "Item 10"
        
        _ = expectationForSaveNotification()
        _ = insertItem(id: id, title: title)
        
        //Assert save is called via notification (wait)
        expectation(forNotification: NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue), object: nil, handler: nil)
        save()
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    
    func expectationForSaveNotification() -> XCTestExpectation {
        let expect = expectation(description: "Context Saved")
        waitForSavedNotification { (notification) in
            expect.fulfill()
        }
        return expect
    }
    
    
    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
        saveNotificationCompleteHandler = completeHandler
    }
    
    
    func contextSaved( notification: Notification ) {
        print("\(notification)")
        saveNotificationCompleteHandler?(notification)
    }
}


//MARK: Creat some fakes
extension MokaPosTests {
    
    func initStubs() {
        _ = insertItem(id: 1, title: "Item 1")
        _ = insertItem(id: 2, title: "Item 2")
        _ = insertItem(id: 3, title: "Item 2")
        _ = insertItem(id: 4, title: "Item 4")
        _ = insertItem(id: 5, title: "Item 5")
        
        do {
            try coreDataStack.mainContext.save()
        }
        catch {
            print("create fake error \(error)")
        }
    }
    
    
    func insertItem(id: Int, title: String) -> Item? {
        let obj = NSEntityDescription.insertNewObject(forEntityName: "Item", into: coreDataStack.mainContext) as! Item
        obj.id = Int64(id)
        obj.thumbnail = "some URL"
        obj.title = title
        obj.price = Double(obj.id) * Double(Int.random(in: 10...99))
        return obj
    }
    
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let objs = try! coreDataStack.mainContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            coreDataStack.mainContext.delete(obj)
        }
        try! coreDataStack.mainContext.save()
    }
    
    
    func fetchAll() -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let results = try? coreDataStack.mainContext.fetch(request)
        return results ?? [Item]()
    }
    
    
    func save() {
        if coreDataStack.mainContext.hasChanges {
            do {
                try coreDataStack.mainContext.save()
            }
            catch {
                print("Save error \(error)")
            }
        }
    }
    
    
    func remove(objectID: NSManagedObjectID) {
        let obj = coreDataStack.mainContext.object(with: objectID)
        coreDataStack.mainContext.delete(obj)
    }
}
