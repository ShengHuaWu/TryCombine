import Combine
import Foundation

var subscriptions: Set<AnyCancellable> = []

public func chapter11() {
    example(of: "Timer") {
        let subscription = Timer
        .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
        .scan(0) { counter, _ in counter + 1 }
        .sink { counter in
            print("Counter is \(counter)")
          }

        subscriptions.insert(subscription)
    }
}
