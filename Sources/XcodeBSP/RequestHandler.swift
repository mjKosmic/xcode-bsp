import Foundation
import LanguageServerProtocol
import JSONRPC

public protocol ErrorHandler {
    func internalError(_ error: Error) async
}

public protocol EventHandler: ErrorHandler {
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
}


extension EventHandler {
    func handleRequest(id: JSONId, request: ClientRequest) async {  
        await defaultHandleRequest(id: id, request: request)
    }

    func defaultHandleRequest(id: JSONId, request: ClientRequest) async {
        switch request {
            case .initialize():
                
        }
    }
}




