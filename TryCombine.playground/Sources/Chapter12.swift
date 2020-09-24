import Combine
import Foundation

public func chapter12() {
    var subscriptions: Set<AnyCancellable> = []
    
    example(of: "ObservableObject") {
        class MonitorObject: ObservableObject {
          @Published var someProperty = false
          @Published var someOtherProperty = ""
        }
        
        let object = MonitorObject()
        
        // Compiler automatically generate `objectWillChange`
        let subscription = object.objectWillChange.sink {
          print("object will change")
        }
        subscriptions.insert(subscription)
        
        // Unfortunately, you can‘t know which property actually changed.
        object.someProperty = true
        object.someOtherProperty = "Hello world"
    }
}
