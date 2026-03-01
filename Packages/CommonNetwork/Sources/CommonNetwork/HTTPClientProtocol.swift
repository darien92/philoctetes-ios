import Foundation

/// Protocol for making HTTP requests. Abstracted for testability.
public protocol HTTPClientProtocol: Sendable {
    /// Execute a request and decode the response.
    func request<T: Decodable & Sendable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T

    /// Execute a request with no response body.
    func request(endpoint: Endpoint) async throws
}
