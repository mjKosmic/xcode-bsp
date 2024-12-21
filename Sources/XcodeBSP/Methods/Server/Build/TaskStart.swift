import JSONRPC
import LanguageServerProtocol


public extension Build.Task {
    struct Start {
        public struct Params: Codable, Hashable, Sendable {
            public let taskId: TaskId
            public let originId: JSONId?
            public let eventTime: Int64?
            public let message: String?
            //data
            //datakind
        }
    }   
}
