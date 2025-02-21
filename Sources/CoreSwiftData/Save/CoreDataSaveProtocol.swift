//
//  CoreSwiftData
//
//  Created by Evan Tsvetkov
//

import CoreData

public protocol CoreDataSaveProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publisher(save action: @escaping Action) -> CoreDataSaveModelPublisher
}

extension CoreDataSaveProtocol {
    public func publisher(save action: @escaping Action) -> CoreDataSaveModelPublisher {
        return CoreDataSaveModelPublisher(action: action,
                                          context: viewContext)
    }
}
