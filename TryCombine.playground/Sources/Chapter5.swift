import Combine
import Foundation

public func chapter5() {
    var subscriptions: Set<AnyCancellable> = []
    
    example(of: "switchToLatest") {
      let publisher1 = PassthroughSubject<Int, Never>()
      let publisher2 = PassthroughSubject<Int, Never>()
      let publisher3 = PassthroughSubject<Int, Never>()
        
      let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
        publishers
            .switchToLatest()
            .sink(receiveCompletion: { _ in print("Completed!") },
                  receiveValue: { print($0) })
            .store(in: &subscriptions)
        
        publishers.send(publisher1)
        publisher1.send(1)
        publisher1.send(2)
        
        publishers.send(publisher2)
        publisher1.send(3)
        publisher2.send(4)
        publisher2.send(5)
        
        publishers.send(publisher3)
        publisher2.send(6)
        publisher3.send(7)
        publisher3.send(8)
        publisher3.send(9)
        
        publisher3.send(completion: .finished)
        publishers.send(completion: .finished)
    }

    example(of: "merge(with:)") {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<Int, Never>()
        
        publisher1
            .merge(with: publisher2)
            .sink(receiveCompletion: { _ in print("Completed") },
                  receiveValue: { print($0) })
            .store(in: &subscriptions)
        
        publisher2.send(0)
        publisher1.send(1)
        publisher1.send(2)
        publisher2.send(3)
        publisher1.send(4)
        publisher2.send(5)
        
        publisher1.send(completion: .finished)
        publisher2.send(completion: .finished)
    }

    example(of: "combineLatest") {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<String, Never>()
        
        publisher1
            .combineLatest(publisher2)
            .sink(receiveCompletion: { _ in print("Completed") },
                  receiveValue: { print("P1: \($0), P2: \($1)") })
            .store(in: &subscriptions)
        
        publisher1.send(1)
        publisher1.send(2)
        
        publisher2.send("a")
        publisher2.send("b")
        
        publisher1.send(3)
        publisher2.send("c")
        
        publisher1.send(completion: .finished)
        publisher2.send(completion: .finished)
    }
}
