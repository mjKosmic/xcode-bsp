import LanguageServerProtocol

public struct ClientCapabilities: Codable, Hashable, Sendable {
    public let languageIds: [LanguageIdentifier] 
}

public struct BuildServerCapabilities: Codable, Sendable {
    public struct CompileProvider: Codable, Sendable {
        public let languageIds: [LanguageIdentifier]
    }

    public struct TestProvider: Codable, Sendable {
        public let languageIds: [LanguageIdentifier]
    }

    public struct RunProvider: Codable, Sendable {
        public let languageIds: [LanguageIdentifier]
    }

    public struct DebugProvider: Codable, Sendable {
        public let languageIds: [LanguageIdentifier]
    }

    /** The languages the server supports compilation via method buildTarget/compile. */
    public let compileProvider: CompileProvider?;

    /** The languages the server supports test execution via method buildTarget/test. */
    public let testProvider: TestProvider?;

    /** The languages the server supports run via method buildTarget/run. */
    public let runProvider: RunProvider?;

    /** The languages the server supports debugging via method debugSession/start. */
    public let debugProvider: DebugProvider?;

    /** The server can provide a list of targets that contain a
     * single text document via the method buildTarget/inverseSources */
    public let inverseSourcesProvider: Bool?

    /** The server provides sources for library dependencies
     * via method buildTarget/dependencySources */
    public let dependencySourcesProvider: Bool?

    /** The server can provide a list of dependency modules (libraries with meta information)
     * via method buildTarget/dependencyModules */
    public let dependencyModulesProvider: Bool?

    /** The server provides all the resource dependencies
     * via method buildTarget/resources */
    public let resourcesProvider: Bool?

    /** The server provides all output paths
     * via method buildTarget/outputPaths */
    public let outputPathsProvider: Bool?

    /** The server sends notifications to the client on build
     * target change events via buildTarget/didChange */
    public let buildTargetChangedProvider: Bool?

    /** Reloading the build state through workspace/reload is supported */
    public let canReload: Bool?
}
