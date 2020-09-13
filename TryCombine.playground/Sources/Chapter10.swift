import Foundation
import Combine

public func chapter10() {
    var subscriptions: Set<AnyCancellable> = []
    
    example(of: "Print events") {
        class TimeLogger: TextOutputStream {
            private var previous = Date()
            private let formatter = NumberFormatter()
            
            init() {
                formatter.maximumFractionDigits = 5
                formatter.minimumFractionDigits = 5
            }
            
            func write(_ string: String) {
                let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                
                let now = Date()
                print("+\(formatter.string(for: now.timeIntervalSince(previous))!)s: \(string)")
                previous = now
            }
        }
        
        
         let subscription = (1...3)
            .publisher
            .print("publisher", to: TimeLogger())
            .sink { _ in }
        
        subscriptions.insert(subscription)
    }

    example(of: "Perform side effects") {
        let request = URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com/")!)
        request
            .handleEvents(receiveSubscription: { _ in
                print("Network request will start")
            }, receiveOutput: { _ in
                print("Network request data received")
            }, receiveCancel: {
                print("Network request cancelled")
            })
            .sink(receiveCompletion: { completion in
                print("Sink received completion: \(completion)")
            }) { (data, _) in
                print("Sink received data: \(data)")
        }
    }
}
