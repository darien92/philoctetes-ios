import Foundation

/// Provides authentication tokens for API requests.
/// Implemented by Firebase Auth (or any other auth provider).
public protocol TokenProviderProtocol: Sendable {
    /// Returns a valid auth token, refreshing if necessary.
    func getToken() async throws -> String
}
