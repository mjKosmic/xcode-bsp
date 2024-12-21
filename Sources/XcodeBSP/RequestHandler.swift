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
    func buildTargetSources(id: JSONId, params: BuildTarget.Sources.Params) async -> Response<BuildTarget.Sources.Result>
    func buildTargetInverseSources(id: JSONId, params: BuildTarget.InverseSources.Params) async -> Response<BuildTarget.InverseSources.Result>
    func buildTargetDependencySources(id: JSONId, params: BuildTarget.DependencySources.Params) async -> Response<BuildTarget.DependencySources.Result>
    func buildTargetDependencyModules(id: JSONId, params: BuildTarget.DependencyModules.Params) async -> Response<BuildTarget.DependencyModules.Result>
    func buildTargetResources(id: JSONId, params: BuildTarget.Resources.Params) async -> Response<BuildTarget.Resources.Result>
    func buildTargetOutputPaths(id: JSONId, params: BuildTarget.OutputPaths.Params) async -> Response<BuildTarget.OutputPaths.Result>
    func buildTargetCompile(id: JSONId, params: BuildTarget.Compile.Params) async -> Response<BuildTarget.Compile.Result>
    func buildTargetRun(id: JSONId, params: BuildTarget.Run.Params) async -> Response<BuildTarget.Run.Result>
    func buildTargetTest(id: JSONId, params: BuildTarget.Test.Params) async -> Response<BuildTarget.Test.Result>
    func buildTargetCleanCache(id: JSONId, params: BuildTarget.CleanCache.Params) async -> Response<BuildTarget.CleanCache.Result>
    func debugSessionStart(id: JSONId, params: DebugSesson.Start.Params) async -> Response<DebugSesson.SessionAddress>
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




