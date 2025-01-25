import JSONRPC
import LanguageServerProtocol
import Foundation
import OSLog

public actor JSONRPCClientConnection: ClientConnection {
	public let eventSequence: EventSequence
	private let eventContinuation: EventSequence.Continuation

	private let session: JSONRPCSession

	/// NOTE: The channel will wrapped with message framing
	public init(_ dataChannel: DataChannel) {
	    self.session = JSONRPCSession(channel: dataChannel.withMessageFraming())

	    (self.eventSequence, self.eventContinuation) = EventSequence.makeStream()

	    Task {  
            await startMonitoringSession()
	    }
	}

	deinit {
        eventContinuation.finish()
	}

	private func startMonitoringSession() async {
        Logger.bsp.debug("Starting JSONRPC session monitor...")
        let seq = await session.eventSequence
        for await event in seq {
            switch event {
                case let .notification(notification, data):
                    let requestString = String(data: data, encoding: .utf8)
                    Logger.bsp.debug("Recieved JSONRPC notification: \(requestString ?? notification.method, privacy: .public)")
                    self.handleNotification(notification, data: data)
                case let .request(request, handler, data):
                    let requestString = String(data: data, encoding: .utf8)
                    Logger.bsp.debug("Recieved JSONRPC request: \(requestString ?? request.method, privacy: .public)")
                    self.handleRequest(request, data: data, handler: handler)
                case let .error(error):
                    Logger.bsp.debug("Recieved JSONRPC error: \(error, privacy: .public)")
                    self.handleError(error)
            }
	    }

		eventContinuation.finish()
	}

	public func stop() {
		eventContinuation.finish()
	}

	private func decodeNotificationParams<Params>(_ type: Params.Type, from data: Data) throws -> Params where Params : Decodable {
		let note = try JSONDecoder().decode(JSONRPCNotification<Params>.self, from: data)

		guard let params = note.params else {
			throw ProtocolError.missingParams
		}

		return params
	}

	private func yield(_ notification: ClientNotification) {
		eventContinuation.yield(.notification(notification))
	}

	private func yield(id: JSONId, request: ClientRequest) {
		eventContinuation.yield(.request(id: id, request: request))
	}

	private func handleNotification(_ anyNotification: AnyJSONRPCNotification, data: Data) {
		let methodName = anyNotification.method

		do {
			guard let method = ClientNotification.Method(rawValue: methodName) else {
				throw ProtocolError.unrecognizedMethod(methodName)
			}

			switch method {
			case .initialized:
				// let params = try decodeNotificationParams(InitializedParams.self, from: data)
				// yield(.initialized(params))
                yield(.initialized)
			case .exit:
				yield(.exit)
			}
		} catch {
			// should we backchannel this to the client somehow?
			print("failed to relay notification: \(error)")
		}
	}

	private func decodeRequestParams<Params>(_ data: Data) throws -> Params where Params : Decodable {
		let req = try JSONDecoder().decode(JSONRPCRequest<Params>.self, from: data)

		guard let params = req.params else {
			throw ProtocolError.missingParams
		}

		return params
	}

	private func decodeRequestParams<Params>(_ type: Params.Type, from data: Data) throws -> Params where Params : Decodable {
		let req = try JSONDecoder().decode(JSONRPCRequest<Params>.self, from: data)

		guard let params = req.params else {
			throw ProtocolError.missingParams
		}

		return params
	}

	private nonisolated func makeHandler<T>(_ handler: @escaping JSONRPCEvent.RequestHandler) -> ServerRequest.Handler<T> {
		return {
			let loweredResult = $0.map({ $0 as Encodable & Sendable })

			await handler(loweredResult)
		}
	}

	private func handleRequest(_ anyRequest: AnyJSONRPCRequest, data: Data, handler: @escaping JSONRPCEvent.RequestHandler) {
		let methodName = anyRequest.method
		let id = anyRequest.id

		do {
            guard let method = ClientRequest.Method(rawValue: methodName) else {
                throw ProtocolError.unrecognizedMethod(methodName)
            }

            switch method {
            case .initialize:
                yield(id: id, request: ClientRequest.initialize(try decodeRequestParams(data), makeHandler(handler)))
            case .shutdown:
                yield(id: id, request: ClientRequest.shutdown(makeHandler(handler)))
            case .workspaceBuildTargets:
                yield(id: id, request: ClientRequest.workspaceBuildTargets(makeHandler(handler)))
            case .workspaceReload:
                yield(id: id, request: ClientRequest.workspaceReload(makeHandler(handler)))
            case .buildTargetSources:
                yield(id: id, request: ClientRequest.buildTargetSources(try decodeRequestParams(data), makeHandler(handler)))
            case .buildTargetInverseSources:
                yield(id: id, request: ClientRequest.buildTargetInverseSources(try decodeRequestParams(data), makeHandler(handler)))
            case .buildTargetDependencySources:
                yield(id: id, request: ClientRequest.buildTargetDependencySources(try decodeRequestParams(data), makeHandler(handler)))
            case .buildTargetDependencyModules:
                yield(id: id, request: ClientRequest.buildTargetDependencyModules(try decodeRequestParams(data), makeHandler(handler)))
            case .buildTargetResources:
                yield(id: id, request: ClientRequest.buildTargetResources(try decodeRequestParams(data), makeHandler(handler)))
            case .buildTargetOutputPaths:
                yield(id: id, request: ClientRequest.buildTargetOutputPaths(try decodeRequestParams(data), makeHandler(handler)))
            case .buildTargetCompile:
                yield(id: id, request: ClientRequest.buildTargetCompile(try decodeRequestParams(data), makeHandler(handler)))
            case .buildTargetRun:
                yield(id: id, request: ClientRequest.buildTargetRun(try decodeRequestParams(data), makeHandler(handler)))
            case .buildTargetTest:
                yield(id: id, request: ClientRequest.buildTargetTest(try decodeRequestParams(data), makeHandler(handler)))
            case .buildTargetCleanCache:
                yield(id: id, request: ClientRequest.buildTargetCleanCache(try decodeRequestParams(data), makeHandler(handler)))
            case .debugSessionStart:
                yield(id: id, request: ClientRequest.debugSessionStart(try decodeRequestParams(data), makeHandler(handler)))
            case .registerForChanges:
                yield(id: id, request: ClientRequest.registerForChanges(try decodeRequestParams(data), makeHandler(handler)))
            case .sourceKitOptions:
                yield(id: id, request: ClientRequest.sourceKitOptions(try decodeRequestParams(data), makeHandler(handler)))
            }
		} catch {
		    eventContinuation.yield(.error(error))
		}
	}

	private func handleError(_ anyError: Error) {
		eventContinuation.yield(.error(anyError))
	}

	public func sendNotification(_ notif: ServerNotification) async throws {
		let method = notif.method.rawValue

		switch notif {
		    case .logMessage(let params):
			try await session.sendNotification(params, method: method)
		    case .showMessage(let params):
			try await session.sendNotification(params, method: method)
		    case .publishDiagnostics(let params):
			try await session.sendNotification(params, method: method)
		    case .targetDidChange(let event):
			try await session.sendNotification(event, method: method)
		    case .taskStart(let params):
			try await session.sendNotification(params, method: method)
		    case .taskProgress(let params):
			try await session.sendNotification(params, method: method)
		    case .taskFinish(let params):
			try await session.sendNotification(params, method: method)
		    case .printStdout:
		        //not supporting this yet
			break
		    case .printStderr:
			//not supporting this yet
			break
		}
	}

    //just for protocol adherence. BSP doesn't currently support Server -> Client requests
    public func sendRequest<Response>(_ request: ServerRequest) async throws -> Response where Response : Decodable, Response : Sendable {
        throw ProtocolError.unrecognizedMethod(request.method.rawValue)
    }
}

