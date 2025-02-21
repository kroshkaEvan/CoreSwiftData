//
//  CoreSwiftData
//
//  Created by Evan Tsvetkov
//

import CoreData

public protocol CoreDataManagerProtocol: EntityCreating,
                                  CoreDataFetchProtocol,
                                  CoreDataSaveProtocol,
                                  CoreDataDeleteModelPublishing {
    var viewContext: NSManagedObjectContext { get }
}

public class CoreDataManager: CoreDataManagerProtocol {
    
    private var container: NSPersistentContainer
    
    var dataBaseName: String
    
    @MainActor
    static let preview: CoreDataManager = {
        let result = CoreDataManager(dataBaseName: "PreviewDatabase",
                                     inMemory: false)
        return result
    }()
    
    public var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    public init(dataBaseName: String, inMemory: Bool = false) {
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
    
    public init(container: NSPersistentContainer) {
        self.container = container
        self.dataBaseName = container.name
    }
}
