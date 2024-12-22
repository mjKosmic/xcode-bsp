import JSONRPC
import LanguageServerProtocol
import Foundation
import OSLog

public actor BSPRequestHandler: RequestHandler {
    public func internalError(_ error: Error) async {
		Logger.bsp.error("Internal Error: \(error.localizedDescription, privacy: .public)")
	}

    public func handleRequest(id: JSONId, request: ClientRequest) async {
        let this = (self as RequestHandler)
        switch request {
            case .initialize(let params, let handler):
                // await handler(await initialize(id: id, params: params)) 
                Logger.bsp.info("Initializing XCode BSP server...")
            case .shutdown(let handler):
                // await handler(.success(nil))
                await this.handleRequest(id: id, request: request)
            case .workspaceBuildTargets(let handler):
                // await handler(workspaceBuildTargets(id: id))
                await this.handleRequest(id: id, request: request)
            case .workspaceReload(let handler):
                // await handler(.success(nil))
                await this.handleRequest(id: id, request: request)
            case .buildTargetSources(let params, let handler):
                // await handler(buildTargetSources(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .buildTargetInverseSources(let params, let handler):
                // await handler(buildTargetInverseSources(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .buildTargetDependencySources(let params, let handler):
                // await handler(buildTargetDependencySources(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .buildTargetDependencyModules(let params, let handler):
                // await handler(buildTargetDependencyModules(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .buildTargetResources(let params, let handler):
                // await handler(buildTargetResources(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .buildTargetOutputPaths(let params, let handler):
                // await handler(buildTargetOutputPaths(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .buildTargetCompile(let params, let handler):
                // await handler(buildTargetCompile(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .buildTargetRun(let params, let handler):
                // await handler(buildTargetRun(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .buildTargetTest(let params, let handler):
                // await handler(buildTargetTest(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .buildTargetCleanCache(let params, let handler):
                // await handler(buildTargetCleanCache(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case .debugSessionStart(let params, let handler):
                // await handler(debugSessionStart(id: id, params: params))
                await this.handleRequest(id: id, request: request)
        }
	}
}
