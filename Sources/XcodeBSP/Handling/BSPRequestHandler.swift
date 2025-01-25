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
                do {
                    try await XcodeBSPServer.shared.initialize(params)
                    let result: Initialize.Result = .init(
                        displayName: XcodeBSP.name,
                        version: XcodeBSP.version,
                        bspVersion: XcodeBSP.bspVersion,
                        capabilities: XcodeBSPServer.capabilities,
                        dataKind: "sourceKit",
                        data: .init(
                            indexStorePath: nil, 
                            indexDatabasePath: nil, 
                            prepareProvider: false, 
                            sourceKitOptionsProvider: true, 
                            watchers: nil
                        )
                    )
                    await handler(.success(result))
                } catch {
                    await handler(.failure(.init(code: 52200, message: "Error initializing BSP server")))
                }

            case let .shutdown(handler):
                Logger.bsp.debug("Shutting down build server...")
                await handler(.success(.null))
                exit(0)
            case .workspaceBuildTargets(let handler):
                Logger.bsp.debug("Fetching workspace build targets")
                let buildTargets = await XcodeBSPServer.shared.buildTargets
                await handler(.success(.init(targets: buildTargets)))
            case .workspaceReload(let handler):
                // await handler(.success(nil))
                await this.handleRequest(id: id, request: request)
            case .buildTargetSources(let params, let handler):
                Logger.bsp.debug("Getting build target sources...")
                
                var targetsSources: [Build.Target.Sources.Item] = []
                for targetId in params.targets {
                    do {
                        let targetSources = try await XcodeBSPServer.shared.sources(for: targetId)
                        targetsSources.append(
                            .init(
                                target: targetId,
                                sources: targetSources,
                                roots: nil
                            )
                        )
                    } catch {
                        Logger.bsp.error("Error getting sources for build target (\(targetId.uri, privacy: .public)): \(error.localizedDescription, privacy: .public)")
                    }
                }
                let result: Build.Target.Sources.Result = .init(items: targetsSources)
                await handler(.success(result))
            case let .buildTargetInverseSources(params, handler):
                // await handler(buildTargetInverseSources(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .buildTargetDependencySources(params, handler):
                // await handler(buildTargetDependencySources(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .buildTargetDependencyModules(params, handler):
                // await handler(buildTargetDependencyModules(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .buildTargetResources(params, handler):
                // await handler(buildTargetResources(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .buildTargetOutputPaths(params, handler):
                // await handler(buildTargetOutputPaths(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .buildTargetCompile(params, handler):
                // await handler(buildTargetCompile(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .buildTargetRun(params, handler):
                // await handler(buildTargetRun(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .buildTargetTest(params, handler):
                // await handler(buildTargetTest(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .buildTargetCleanCache(params, handler):
                // await handler(buildTargetCleanCache(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .debugSessionStart(params, handler):
                // await handler(debugSessionStart(id: id, params: params))
                await this.handleRequest(id: id, request: request)
            case let .registerForChanges(params, handler):
                await this.handleRequest(id: id, request: request)
            case let .sourceKitOptions(params, handler):
                let result = await XcodeBSPServer.shared.sourceKitOptions(for: params)
                await handler(.success(result))
        }
	}
}
