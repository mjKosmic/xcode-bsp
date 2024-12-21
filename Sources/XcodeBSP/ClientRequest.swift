import LanguageServerProtocol
import JSONRPC



public enum ClientNotification: Sendable {
    public enum Method: String, Hashable, Sendable {
        case initialized = "build/initialized"
        case exit = "build/exit"
        case runReadStdin = "run/readStdin"
    }
}

public enum ClientRequest: Sendable {
    public typealias Handler<T: Sendable & Encodable> = @Sendable (Result<T, AnyJSONRPCResponseError>) async -> Void
    public typealias ErrorOnlyHandler = @Sendable(AnyJSONRPCResponseError?) async -> Void
    
    public enum Method: String, Hashable, Sendable {
        case initialize = "build/initialize"
        case shutdown = "build/shutdown"
        case workspaceBuildTargets = "workspace/buildTargets"
        case workspaceReload = "workspace/reload"
        case buildTargetSources = "buildTarget/sources"
        case buildTargetInverseSources = "buildTarget/inverseSources"
        case buildTargetDependencySources = "buildTarget/dependencySources"
        case buildTargetDependencyModules = "buildTarget/dependencyModules"
        case buildTargetResources = "buildTarget/resources"
        case buildTargetOutputPaths = "buildTarget/outputPaths"
        case buildTargetCompile = "buildTarget/compile"
        case buildTargetRun = "buildTarget/run"
        case buildTargetTest = "buildTarget/test"
        case debugSessionStart = "debugSession/start"
        case buildTargetCleanCache = "buildTarget/cleanCache"
    }

    case initialize(InitializeBuildParams, Handler<InitializeBuildResult>)
    case shutdown
    case workspaceBuildTargets
    case workspaceReload
    case buildTargetSources
    case buildTargetInverseSources
    case buildTargetDependencySources
    case buildTargetDependencyModules
    case buildTargetResources
    case buildTargetOutputPaths
    case buildTargetCompile
    case buildTargetRun
    case buildTargetTest
    case debugSessionStart
    case buildTargetCleanCache

    public var method: Method {
        switch self {
        case .initialize: 
            return .initialize
        case .shutdown:
			return .shutdown
        case .workspaceBuildTargets:
			return .workspaceBuildTargets
        case .workspaceReload:
			return .workspaceReload
        case .buildTargetSources:
			return .buildTargetSources
        case .buildTargetInverseSources:
			return .buildTargetInverseSources
        case .buildTargetDependencySources:
			return .buildTargetDependencySources
        case .buildTargetDependencyModules:
			return .buildTargetDependencyModules
        case .buildTargetResources:
			return .buildTargetResources
        case .buildTargetOutputPaths:
			return .buildTargetOutputPaths
        case .buildTargetCompile:
			return .buildTargetCompile
        case .buildTargetRun:
			return .buildTargetRun
        case .buildTargetTest:
			return .buildTargetTest
        case .debugSessionStart:
			return .debugSessionStart
        case .buildTargetCleanCache:
			return .buildTargetCleanCache
        }
    }
}
