//
//  CoreSwiftData
//
//  Created by Evan Tsvetkov
//

import CoreData

protocol CoreDataFetchProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T>
}

extension CoreDataFetchProtocol {
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T> {
        return CoreDataFetchResultsPublisher(request: request,
                                             context: viewContext)
    }
}
