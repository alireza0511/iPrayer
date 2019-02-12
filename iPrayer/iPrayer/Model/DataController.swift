//
//  DataController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/23/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import CoreData
// core data stack start with 4.1
class DataController {
    //3- help us access the context
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    //1- hold a presistent container instance
    let persistentContainer: NSPersistentContainer
    
    init(modelName:String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    //2- help us load the persistent store
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            completion?()
        }
    }
    
}

extension DataController{
    func autoSaveViewContext(interval: TimeInterval = 30) {
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
            }
}
}



