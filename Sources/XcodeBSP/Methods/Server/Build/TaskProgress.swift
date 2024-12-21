import JSONRPC
import LanguageServerProtocol


public extension Build.Task {
    struct Progress {
        public struct Params: Codable, Hashable, Sendable {
            public let taskId: TaskId
            public let originId: JSONId?
            public let eventTime: Int64?
            public let message: String?
            public let total: Int64?
            public let progress: Int64?
            public let unit: String?
            //data
            //datakind
        }   
    }   
}
