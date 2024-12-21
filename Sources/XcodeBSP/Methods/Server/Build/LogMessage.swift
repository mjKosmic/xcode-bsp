import JSONRPC


public extension Build  {
    struct LogMessage {
        public struct Params: Codable, Hashable, Sendable {
            public let type: MessageType
            public let task: TaskId?
            public let originId: JSONId?
            public let message: String
        }
    }
}
