import Foundation
import LanguageServerProtocol

public struct BuildTarget: Codable, Sendable {
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

extension BuildTarget.Tag {
  public static let application = "application"
  public static let benchmark = "benchmark"
  public static let integrationTest = "integration-test"
  public static let library = "library"
  public static let manual = "manual"
  public static let noIde = "no-ide"
  public static let test = "test"
}

public enum StatusCode: Int, Codable, Hashable, Sendable {
    case ok = 1
    case error
    case canceled
}   

public typealias EnvironmentVariable = [String: String]
