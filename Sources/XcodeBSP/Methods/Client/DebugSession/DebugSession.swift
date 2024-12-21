import Foundation

public struct DebugSession {
    public struct SessionAddress: Codable, Hashable, Sendable {
        public let uri: URL
    }
}
