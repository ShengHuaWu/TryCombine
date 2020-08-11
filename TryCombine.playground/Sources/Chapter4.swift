import Combine
import Foundation

public func chatper4() {
    var subscriptions: Set<AnyCancellable> = []
    
    example(of: "ignoreOutput") {
        let numbers = (1...10_000).publisher
        numbers
            .ignoreOutput()
            .sink(receiveCompletion: { print("Completed with: \($0)") },
                  receiveValue: { print($0) })
            .store(in: &subscriptions)
    }

    example(of: "drop(untilOutputFrom:)") {
        let isReady = PassthroughSubject<Void, Never>()
        let taps = PassthroughSubject<Int, Never>()
        
        taps
            .drop(untilOutputFrom: isReady)
            .sink(receiveValue: { print($0) })
            .store(in: &subscriptions)
        
        (1...5).forEach { n in
            taps.send(n)
            if n == 3 { isReady.send() }
        }
    }

    example(of: "prefix(untilOutputFrom:)") {
        let isReady = PassthroughSubject<Void, Never>()
        let taps = PassthroughSubject<Int, Never>()
        
        taps
            .prefix(untilOutputFrom: isReady)
            .sink(receiveCompletion: { print("Completed with: \($0)") },
                  receiveValue: { print($0) })
            .store(in: &subscriptions)
        
        (1...5).forEach { n in
            taps.send(n)
            if n == 4 { isReady.send() }
        }
    }

    example(of: "chapter 4 challenge: filter all the things") {
        let numbers = (1...100).publisher
        
        numbers
            .dropFirst(50)
            .prefix(20)
            .filter { $0 % 2 == 0 }
            .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
    }
}
