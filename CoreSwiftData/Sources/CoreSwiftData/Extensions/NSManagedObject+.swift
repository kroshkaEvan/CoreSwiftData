//
//  CoreSwiftData
//
//  Created by Evan Tsvetkov
//

import CoreData

extension NSManagedObject {
    class var entityName: String {
        return String(describing: self).components(separatedBy: ".").last ?? "UnknownEntity"
    }
}
