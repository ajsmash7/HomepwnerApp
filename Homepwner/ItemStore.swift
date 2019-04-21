//
//  ItemStore.swift
//  Homepwner
//
//  Created by AJMac on 4/15/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] {
            allItems = archivedItems
        }
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        return newItem
        
        
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.index(of: item){
            allItems.remove(at: index)
        }
    }
    
    func moveItem (from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        //get reference of object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        //Remove item from array
        allItems.remove(at: fromIndex)
        
        //Insert in new location
        allItems.insert(movedItem, at: toIndex)
    }
    
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
    
}
