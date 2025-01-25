import Foundation
import LanguageServerProtocol
import JSONRPC

public protocol ErrorHandler {
    func internalError(_ error: Error) async
}

public protocol RequestHandler: ErrorHandler {
    typealias Handler = ClientRequest.Handler
    typealias Response<T> = Result<T, AnyJSONRPCResponseError>

    func handleRequest(id: JSONId, request: ClientRequest) async
    
    func initialize(id: JSONId, params: Initialize.Params) async -> Response<Initialize.Result>
    func shutdown(id: JSONId) async
    func workspaceBuildTargets(id: JSONId) async -> Response<Workspace.BuildTargets.Result>
    func workspaceReload(id: JSONId) async -> Response<AnyJSONRPCResponseError?>
    func buildTargetSources(id: JSONId, params: Build.Target.Sources.Params) async -> Response<Build.Target.Sources.Result>
    func buildTargetInverseSources(id: JSONId, params: Build.Target.InverseSources.Params) async -> Response<Build.Target.InverseSources.Result>
    func buildTargetDependencySources(id: JSONId, params: Build.Target.DependencySources.Params) async -> Response<Build.Target.DependencySources.Result>
    func buildTargetDependencyModules(id: JSONId, params: Build.Target.DependencyModules.Params) async -> Response<Build.Target.DependencyModules.Result>
    func buildTargetResources(id: JSONId, params: Build.Target.Resources.Params) async -> Response<Build.Target.Resources.Result>
    func buildTargetOutputPaths(id: JSONId, params: Build.Target.OutputPaths.Params) async -> Response<Build.Target.OutputPaths.Result>
    func buildTargetCompile(id: JSONId, params: Build.Target.Compile.Params) async -> Response<Build.Target.Compile.Result>
    func buildTargetRun(id: JSONId, params: Build.Target.Run.Params) async -> Response<Build.Target.Run.Result>
    func buildTargetTest(id: JSONId, params: Build.Target.Test.Params) async -> Response<Build.Target.Test.Result>
    func buildTargetCleanCache(id: JSONId, params: Build.Target.CleanCache.Params) async -> Response<Build.Target.CleanCache.Result>
    func debugSessionStart(id: JSONId, params: DebugSession.Start.Params) async -> Response<DebugSession.SessionAddress>
    func registerForChanges(id: JSONId, params: TextDocument.RegisterForChanges.Params) async -> Response<VoidResponse>
    func sourceKitOptions(id: JSONId, params: TextDocument.SourceKitOptions.Params) async -> Response<TextDocument.SourceKitOptions.Result>
    // func sourceKitOptions(id: JSONId, params: TextDocument.SourceKitOptions.Params) async -> Response<LSPAny>
}


extension RequestHandler {
    func handleRequest(id: JSONId, request: ClientRequest) async {  
        await defaultHandleRequest(id: id, request: request)
    }

    func defaultHandleRequest(id: JSONId, request: ClientRequest) async {
        switch request {
            case let .initialize(params, handler):
                await handler(await initialize(id: id, params: params)) 
            case let .shutdown(handler):
                await handler(.success(nil))
            case let .workspaceBuildTargets(handler):
                await handler(workspaceBuildTargets(id: id))
            case let .workspaceReload(handler):
                await handler(.success(nil))
            case let .buildTargetSources(params, handler):
                await handler(buildTargetSources(id: id, params: params))
            case let .buildTargetInverseSources(params, handler):
                await handler(buildTargetInverseSources(id: id, params: params))
            case let .buildTargetDependencySources(params, handler):
                await handler(buildTargetDependencySources(id: id, params: params))
            case let .buildTargetDependencyModules(params, handler):
                await handler(buildTargetDependencyModules(id: id, params: params))
            case let .buildTargetResources(params, handler):
                await handler(buildTargetResources(id: id, params: params))
            case let .buildTargetOutputPaths(params, handler):
                await handler(buildTargetOutputPaths(id: id, params: params))
            case let .buildTargetCompile(params, handler):
                await handler(buildTargetCompile(id: id, params: params))
            case let .buildTargetRun(params, handler):
                await handler(buildTargetRun(id: id, params: params))
            case let .buildTargetTest(params, handler):
                await handler(buildTargetTest(id: id, params: params))
            case let .buildTargetCleanCache(params, handler):
                await handler(buildTargetCleanCache(id: id, params: params))
            case let .debugSessionStart(params, handler):
                await handler(debugSessionStart(id: id, params: params))
            case let .registerForChanges(params, handler):
                await handler(registerForChanges(id: id, params: params))
            case let .sourceKitOptions(params, handler):
                await handler(sourceKitOptions(id: id, params: params))
        }
    }
}

let NotImplementedError = AnyJSONRPCResponseError(code: ErrorCodes.InternalError, message: "Not implemented")

//Default implementation of "Not Implemented" that we can override when we implement them
public extension RequestHandler {
    func initialize(id: JSONId, params: Initialize.Params) async -> Response<Initialize.Result> { .failure(NotImplementedError) }
    func shutdown(id: JSONId) async { }
    func workspaceBuildTargets(id: JSONId) async -> Response<Workspace.BuildTargets.Result> { .failure(NotImplementedError) }
    func workspaceReload(id: JSONId) async -> Response<AnyJSONRPCResponseError?> { .failure(NotImplementedError) }
    func buildTargetSources(id: JSONId, params: Build.Target.Sources.Params) async -> Response<Build.Target.Sources.Result> { .failure(NotImplementedError) }
    func buildTargetInverseSources(id: JSONId, params: Build.Target.InverseSources.Params) async -> Response<Build.Target.InverseSources.Result> { .failure(NotImplementedError) }
    func buildTargetDependencySources(id: JSONId, params: Build.Target.DependencySources.Params) async -> Response<Build.Target.DependencySources.Result> { .failure(NotImplementedError) }
    func buildTargetDependencyModules(id: JSONId, params: Build.Target.DependencyModules.Params) async -> Response<Build.Target.DependencyModules.Result> { .failure(NotImplementedError) }
    func buildTargetResources(id: JSONId, params: Build.Target.Resources.Params) async -> Response<Build.Target.Resources.Result> { .failure(NotImplementedError) }
    func buildTargetOutputPaths(id: JSONId, params: Build.Target.OutputPaths.Params) async -> Response<Build.Target.OutputPaths.Result> { .failure(NotImplementedError) }
    func buildTargetCompile(id: JSONId, params: Build.Target.Compile.Params) async -> Response<Build.Target.Compile.Result> { .failure(NotImplementedError) }
    func buildTargetRun(id: JSONId, params: Build.Target.Run.Params) async -> Response<Build.Target.Run.Result> { .failure(NotImplementedError) }
    func buildTargetTest(id: JSONId, params: Build.Target.Test.Params) async -> Response<Build.Target.Test.Result> { .failure(NotImplementedError) }
    func buildTargetCleanCache(id: JSONId, params: Build.Target.CleanCache.Params) async -> Response<Build.Target.CleanCache.Result> { .failure(NotImplementedError) }
    func debugSessionStart(id: JSONId, params: DebugSession.Start.Params) async -> Response<DebugSession.SessionAddress> { .failure(NotImplementedError) }
    func registerForChanges(id: JSONId, params: TextDocument.RegisterForChanges.Params) async -> Response<VoidResponse> { .success(VoidResponse()) }
    func sourceKitOptions(id: JSONId, params: TextDocument.SourceKitOptions.Params) async -> Response<TextDocument.SourceKitOptions.Result> { .failure(NotImplementedError) }
    // func sourceKitOptions(id: JSONId, params: TextDocument.SourceKitOptions.Params) async -> Response<LSPAny> { .success(.null) }
}




