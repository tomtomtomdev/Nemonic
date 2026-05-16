import Foundation

nonisolated enum JSONValue: Equatable, Sendable {
    case int(Int)
    case string(String)
}
