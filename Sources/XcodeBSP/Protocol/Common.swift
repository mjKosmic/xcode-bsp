import Foundation
import LanguageServerProtocol

public struct Build {}

public extension Build {
    struct Target: Codable, Sendable {
        public typealias Tag = String
        public struct Identifier: Codable, Hashable, Sendable {
            public let uri: URL 
        }

        public struct Capabilities: Codable, Sendable {
            public let canCompile: Bool?
            public let canTest: Bool?
            public let canRun: Bool?
            public let canDebug: Bool?
        }

        public let id: Identifier
        public let displayName: String?
        public let baseDirectory: URL?
        public let tags: [Tag]
        public let languageIds: [LanguageIdentifier]
        public let dependencies: [Identifier]
        public let capabilities: [Capabilities]
    }
}   

public extension Build.Target.Tag {
    static let application = "application"
    static let benchmark = "benchmark"
    static let integrationTest = "integration-test"
    static let library = "library"
    static let manual = "manual"
    static let noIde = "no-ide"
    static let test = "test"
}

public extension Build {
    struct Task: Codable, Sendable {}
}

public extension Build {
    struct Diagnostics {}
}

public enum StatusCode: Int, Codable, Hashable, Sendable {
    case ok = 1
    case error
    case canceled
}   

public typealias EnvironmentVariable = [String: String]
public typealias Identifier = String

public struct TaskId: Codable, Hashable, Sendable {
    public let id: Identifier
    public let parents: [Identifier]?
}
