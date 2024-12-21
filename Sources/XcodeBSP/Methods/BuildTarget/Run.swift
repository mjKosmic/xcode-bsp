import Foundation
import LanguageServerProtocol
import JSONRPC

public extension BuildTarget {
    public struct Run {
        public struct Params: Codable, Hashable, Sendable {
            public let target: BuildTarget.Identifier
            public let originId: JSONId?
            public let arguments: [String]?
            public let environmentVariables: [EnvironmentVariable]?
            public let workingDirectory:  [URL]?
            //data
            //datakind
        }

        public struct Result: Codable, Sendable {
            public let originId: JSONId?
            public let statusCode: StatusCode
        }
    }
}
