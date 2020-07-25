import Foundation
import Combine

/*
 Publishers do not emit any values if there are no subscribers to potentially receive the output.
 
 A publisher can emit zero or more values but only one completion event, which can either be a normal completion event or an error.
 Once a publisher emits a completion event, it’s finished and can no longer emit any more events.
 
 The sink operator will continue to receive as many values as the publisher emits.
 */

var subscriptions: Set<AnyCancellable> = []

public func chapter2() {
    example(of: "Publisher") {
        let center = NotificationCenter.default
        let myNotification = Notification.Name("MyNotification")
        let publisher = center.publisher(for: myNotification, object: nil)
        
        let subscription = publisher.sink { _ in
            print("Notification received from a publisher!")
        }
        center.post(name: myNotification, object: nil)
        subscription.cancel()
    }
    
    example(of: "Just") {
        let just = Just("Hello world!")
        _ = just .sink(
            receiveCompletion: {
                print("Received completion", $0)
        },
            receiveValue: {
                print("Received value", $0)
        })
    }
    
    example(of: "Custom Subscriber") {
        let publisher = (1...6).publisher
        
        final class IntSubscriber: Subscriber {
            typealias Input = Int
            typealias Failure = Never
            
            func receive(subscription: Subscription) {
                subscription.request(.max(3))
            }
            
            func receive(_ input: Int) -> Subscribers.Demand {
                print("Received value", input)
                return .none
            }
            
            func receive(completion: Subscribers.Completion<Never>) {
                // You did not receive a completion event.
                // This is because the publisher has a finite number of values,
                // and you specified a demand of .max(3).
                print("Received completion", completion)
            }
        }
        
        let subscriber = IntSubscriber()
        publisher.subscribe(subscriber)
    }
    
    example(of: "Future") {
        func futureIncrement(
            integer: Int,
            afterDelay delay: TimeInterval) -> Future<Int, Never> {
            Future<Int, Never> { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    promise(.success(integer + 1))
                }
            }
        }
        
        let future = futureIncrement(integer: 1, afterDelay: 3)
        
        future
            .sink(
                receiveCompletion: { print($0) },
                receiveValue: { print($0) })
            .store(in: &subscriptions)
    }
}
