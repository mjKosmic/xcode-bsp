import Foundation
import LanguageServerProtocol
import JSONRPC

public extension BuildTarget {
    struct Compile {
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [BuildTarget.Identifier]
            public let originId: JSONId?
            public let arguments: [String]?
        }

        public struct Result: Codable, Sendable {
            public let originId: JSONId?
            public let statusCode: StatusCode
            //data
            //datakind
        }
    }
}
