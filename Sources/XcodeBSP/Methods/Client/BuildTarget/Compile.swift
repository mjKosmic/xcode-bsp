import Foundation
import LanguageServerProtocol
import JSONRPC

public extension Build.Target {
    struct Compile {
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [Build.Target.Identifier]
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
