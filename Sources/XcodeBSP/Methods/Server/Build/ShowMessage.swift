import JSONRPC
import LanguageServerProtocol


public extension Build {
    typealias Message = String
    
    enum MessageType: Int, Codable, Hashable, Sendable {
        case error = 1
        case warning
        case info
        case log
    }

    struct ShowMessage {
        public struct Params: Codable, Hashable, Sendable {
            public let type: MessageType
            public let task: TaskId?
            public let originId: JSONId? 
            public let message: String
        }
    }
}
