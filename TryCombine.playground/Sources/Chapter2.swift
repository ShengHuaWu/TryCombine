import Foundation
import Combine

/*
 Publishers do not emit any values if there are no subscribers to potentially receive the output.
 
 A publisher can emit zero or more values but only one completion event, which can either be a normal completion event or an error.
 Once a publisher emits a completion event, it’s finished and can no longer emit any more events.
 
 The sink operator will continue to receive as many values as the publisher emits.
 */
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
}
