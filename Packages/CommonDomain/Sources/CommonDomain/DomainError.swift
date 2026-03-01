import Foundation

/// Shared domain-level errors used across features.
public enum DomainError: LocalizedError, Equatable, Sendable {
    case validation(String)
    case notFound(String)
    case unauthorized
    case networkUnavailable
    case serverError(String)
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .validation(let message): return message
        case .notFound(let entity): return "\(entity) not found"
        case .unauthorized: return "You are not authorized to perform this action"
        case .networkUnavailable: return "No network connection available"
        case .serverError(let message): return "Server error: \(message)"
        case .unknown(let message): return message
        }
    }
}
