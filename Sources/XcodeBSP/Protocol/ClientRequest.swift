import LanguageServerProtocol
import JSONRPC

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
        case buildTargetCleanCache = "buildTarget/cleanCache"
        case debugSessionStart = "debugSession/start"
        case registerForChanges = "textDocument/registerForChanges"
        // case sourceKitOptions = "textDocument/sourceKitOptions"
    }

    case initialize(Initialize.Params, Handler<Initialize.Result>)
    case shutdown(Handler<LSPAny?>)
    case workspaceBuildTargets(Handler<Workspace.BuildTargets.Result>)
    case workspaceReload(Handler<LSPAny?>)
    case buildTargetSources(Build.Target.Sources.Params, Handler<Build.Target.Sources.Result>)
    case buildTargetInverseSources(Build.Target.InverseSources.Params, Handler<Build.Target.InverseSources.Result>)
    case buildTargetDependencySources(Build.Target.DependencySources.Params, Handler<Build.Target.DependencySources.Result>)
    case buildTargetDependencyModules(Build.Target.DependencyModules.Params, Handler<Build.Target.DependencyModules.Result>)
    case buildTargetResources(Build.Target.Resources.Params, Handler<Build.Target.Resources.Result>)
    case buildTargetOutputPaths(Build.Target.OutputPaths.Params, Handler<Build.Target.OutputPaths.Result>)
    case buildTargetCompile(Build.Target.Compile.Params, Handler<Build.Target.Compile.Result>)
    case buildTargetRun(Build.Target.Run.Params, Handler<Build.Target.Run.Result>)
    case buildTargetTest(Build.Target.Test.Params, Handler<Build.Target.Test.Result>)
    case buildTargetCleanCache(Build.Target.CleanCache.Params, Handler<Build.Target.CleanCache.Result>)
    case debugSessionStart(DebugSession.Start.Params, Handler<DebugSession.SessionAddress>)
    case registerForChanges(TextDocument.RegisterForChanges.Params, Handler<VoidResponse>)

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
        case .buildTargetCleanCache:
            return .buildTargetCleanCache
        case .debugSessionStart:
            return .debugSessionStart
        case .registerForChanges:
            return .registerForChanges
        }
    }
}
