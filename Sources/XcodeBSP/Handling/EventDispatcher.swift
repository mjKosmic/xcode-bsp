import JSONRPC
import OSLog


public protocol EventHandler : NotificationHandler, RequestHandler, ErrorHandler {}

public actor EventDispatcher {
	private let connection: JSONRPCClientConnection
  	private let requestHandler: BSPRequestHandler
  	private let notificationHandler: BSPNotificationHandler
  	private let errorHandler: BSPErrorHandler

	public init(connection: JSONRPCClientConnection, requestHandler: BSPRequestHandler, notificationHandler: BSPNotificationHandler, errorHandler: BSPErrorHandler) {
		self.connection = connection
		self.requestHandler = requestHandler
		self.notificationHandler = notificationHandler
		self.errorHandler = errorHandler
	}

	public func run() async {
		await monitorEvents()
	}

	private func monitorEvents() async {
		for await event in connection.eventSequence {
			switch event {
			case let .notification(notification):
                Logger.bsp.debug("Dispatching recieved notification: \(notification.method.rawValue, privacy: .public)")
				await notificationHandler.handleNotification(notification)
			case let .request(id, request):
                Logger.bsp.debug("Dispatching recieved request: \(request.method.rawValue, privacy: .public)")
				await requestHandler.handleRequest(id: id, request: request)
			case let .error(error):
                Logger.bsp.debug("Dispatching recieved error: \(error, privacy: .public)")
				await errorHandler.internalError(error)
			}
		}
	}
}

