//
//  CoreSwiftData
//
//  Created by Evan Tsvetkov
//

import Combine
import CoreData

public typealias Action = () -> Void

public struct CoreDataSaveModelPublisher: Publisher {
    public typealias Output = Bool
    public typealias Failure = Error

    private let action: Action
    private let context: NSManagedObjectContext

    public init(action: @escaping Action,
         context: NSManagedObjectContext) {
        self.action = action
        self.context = context
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Subscription(subscriber: subscriber,
                                        context: context,
                                        action: action)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataSaveModelPublisher {
    class Subscription<S> where S: Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private let action: Action
        private let context: NSManagedObjectContext

        init(subscriber: S, context: NSManagedObjectContext, action: @escaping Action) {
            self.subscriber = subscriber
            self.context = context
            self.action = action
        }
    }
}

extension CoreDataSaveModelPublisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }

        do {
            action()
            demand -= 1
            try context.save()
            demand += subscriber.receive(true)
        } catch {
            subscriber.receive(completion: .failure(error as NSError))
        }
    }
}

extension CoreDataSaveModelPublisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
    }
}
