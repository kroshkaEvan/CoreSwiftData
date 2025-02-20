//
//  CoreSwiftData
//
//  Created by Evan Tsvetkov
//

import CoreData

protocol CoreDataManagerProtocol: EntityCreating,
                                  CoreDataFetchProtocol,
                                  CoreDataSaveProtocol,
                                  CoreDataDeleteModelPublishing {
    var viewContext: NSManagedObjectContext { get }
}

open class CoreDataManager: CoreDataManagerProtocol {
    
    var container: NSPersistentContainer
    
    var dataBaseName: String
    
    @MainActor
    static let preview: CoreDataManager = {
        let result = CoreDataManager(dataBaseName: dataBaseName,
                                     inMemory: false)
        return result
    }()
    
    var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    init(dataBaseName: String, inMemory: Bool = false) {
        self.dataBaseName = dataBaseName
        container = NSPersistentContainer(name: self.dataBaseName)
        if inMemory {
            if let firstDescription = container.persistentStoreDescriptions.first {
                firstDescription.url = URL(fileURLWithPath: "/dev/null")
            }
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                /*
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.dataBaseName = container.name
    }
}
