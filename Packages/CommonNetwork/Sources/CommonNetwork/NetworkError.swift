import Foundation

public enum NetworkError: LocalizedError, Equatable, Sendable {
    case invalidURL
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case decodingFailed(String)
    case noConnection
    case timeout
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .notFound: return "Resource not found"
        case .serverError(let code): return "Server error (\(code))"
        case .decodingFailed(let detail): return "Failed to decode response: \(detail)"
        case .noConnection: return "No internet connection"
        case .timeout: return "Request timed out"
        case .unknown(let message): return message
        }
    }
}
