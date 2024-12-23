import JSONRPC

public enum ClientEvent: Sendable {
	public typealias RequestResult = Result<Encodable & Sendable, AnyJSONRPCResponseError>
	public typealias RequestHandler = @Sendable (RequestResult) async -> Void

	case request(id: JSONId, request: ClientRequest)
	case notification(ClientNotification)
	case error(Error)
	// case error(ClientError)
}

public enum ServerEvent: Sendable {
	public typealias RequestResult = Result<Encodable & Sendable, AnyJSONRPCResponseError>
	public typealias RequestHandler = @Sendable (RequestResult) async -> Void

	// BSP does not contain any Server -> Client requests
	// case request(id: JSONId, request: ServerRequest)
	case notification(ServerNotification)
	case error(Error)
	// case error(ServerError)
}

public struct VoidResponse: Codable, Hashable, Sendable {}


