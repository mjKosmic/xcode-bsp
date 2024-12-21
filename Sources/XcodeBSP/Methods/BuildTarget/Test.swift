import Foundation
import LanguageServerProtocol
import JSONRPC

public extension BuildTarget {
    struct Test {
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [BuildTarget.Identifier]
            public let originId: JSONId?
            public let arguments: [String]?
            public let environmentVariables: [EnvironmentVariable]?
            public let workingDirectory: URL?
            //data
            //dataKind
        }

        public struct Result: Codable, Sendable {
            public let originId: JSONId?
            public let statusCode: StatusCode
            //data
            //datakind
        }
    }   
}
