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
    
    func initialize(id: JSONId, params: InitializeBuildParams) async -> Response<InitializeBuildResult>
    func shutdown(id: JSONId) async
    func workspaceBuildTargets(id: JSONId, params: ) async -> Response<>
    func workspaceReload(id: JSONId, params: ) async -> Response<>
    func buildTargetSources(id: JSONId, params: ) async -> Response<>
    func buildTargetInverseSources(id: JSONId, params: ) async -> Response<>
    func buildTargetDependencySources(id: JSONId, params: ) async -> Response<>
    func buildTargetDependencyModules(id: JSONId, params: ) async -> Response<>
    func buildTargetResources(id: JSONId, params: ) async -> Response<>
    func buildTargetOutputPaths(id: JSONId, params: ) async -> Response<>
    func buildTargetCompile(id: JSONId, params: ) async -> Response<>
    func buildTargetRun(id: JSONId, params: ) async -> Response<>
    func buildTargetTest(id: JSONId, params: ) async -> Response<>
    func debugSessionStart(id: JSONId, params: ) async -> Response<>
    func buildTargetCleanCache(id: JSONId, params: ) async -> Response<>
}


extension EventHandler {
    func handleRequest(id: JSONId, request: ClientRequest) async {  
        await defaultHandleRequest(id: id, request: request)
    }

    func defaultHandleRequest(id: JSONId, request: ClientRequest) async {
        switch request {
            case .initialize(:
                
        }
    }
}




