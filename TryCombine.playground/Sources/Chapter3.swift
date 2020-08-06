import Combine
import Foundation

public func chapter3() {
    var subscriptions: Set<AnyCancellable> = []
    
    example(of: "collect") {
        ["A", "B", "C", "D", "E"]
            .publisher
            .collect(2)
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
            .store(in: &subscriptions)
    }

    struct Coordinate {
        let x: Int
        let y: Int
    }

    example(of: "map key paths") {
        let publisher = PassthroughSubject<Coordinate, Never>()
        publisher
            .map(\.x, \.y).sink(receiveValue: { x, y in
                print("The coordinate at (\(x), \(y))")
            })
            .store(in: &subscriptions)
        publisher.send(Coordinate(x: 10, y: -8))
        publisher.send(Coordinate(x: 0, y: 5))
    }

    example(of: "scan") {
        var dailyGainLoss: Int { .random(in: -10...10) }
        let august2019 = (0..<22) .map { _ in dailyGainLoss } .publisher
        august2019
            .scan(50) { latest, current in
                max(0, latest + current)
        }
        .sink(receiveValue: { _ in })
        .store(in: &subscriptions)
    }
}
