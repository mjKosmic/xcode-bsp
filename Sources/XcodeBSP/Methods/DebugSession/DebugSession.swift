import Foundation

public struct DebugSesson {
    public struct SessionAddress: Codable, Hashable, Sendable {
        public let uri: URL
    }
}
