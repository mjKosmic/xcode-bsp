import JSONRPC
import LanguageServerProtocol


public extension Build.Task {
    struct Finish {
        public struct Params: Codable, Hashable, Sendable {
            public let taskId: TaskId
            public let originId: JSONId?
            public let eventTime: Int64?
            public let message: String?
            public let status: StatusCode
            //data
            //datakind
        }
    }   
}
