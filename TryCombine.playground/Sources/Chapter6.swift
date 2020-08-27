import Combine
import Foundation

/*
`debounce` waits for a pause in values it receives, then emits the latest one after the
specified interval.
 
`throttle` waits for the specified interval, then emits either the first or the latest of the values it received during that interval. It does NOT care about pauses.
 
 `measureInterval(using:)` operator is the tool when we need to find out the time that elapsed between two consecutive values emitted by a publisher.
*/
