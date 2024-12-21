import JSONRPC

extension JSONRPCSession {
    func sendResponse<T>(_ response: JSONRPCResponse<T>) async throws {
        // try await encodeAndWrite(response)
    }
}
