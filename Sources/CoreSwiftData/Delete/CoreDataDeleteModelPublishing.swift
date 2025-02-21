//
//  CoreSwiftData
//
//  Created by Evan Tsvetkov
//

import CoreData

public protocol CoreDataDeleteModelPublishing {
    var viewContext: NSManagedObjectContext { get }
    func publisher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher
}

extension CoreDataDeleteModelPublishing {
    public func publisher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher {
        return CoreDataDeleteModelPublisher(delete: request,
                                            context: viewContext)
    }
}
