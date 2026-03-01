import Foundation

public struct Endpoint: Sendable {
    public let path: String
    public let method: HTTPMethod
    public let headers: [String: String]
    public let queryItems: [URLQueryItem]
    public let body: Data?

    public init(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }

    /// Create an endpoint with a JSON-encodable body.
    public static func withJSON<T: Encodable & Sendable>(
        path: String,
        method: HTTPMethod = .post,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        body: T,
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> Endpoint {
        let data = try encoder.encode(body)
        var allHeaders = headers
        allHeaders["Content-Type"] = "application/json"
        return Endpoint(
            path: path,
            method: method,
            headers: allHeaders,
            queryItems: queryItems,
            body: data
        )
    }
}
