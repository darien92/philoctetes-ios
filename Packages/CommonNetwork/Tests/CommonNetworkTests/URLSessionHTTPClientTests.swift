import Testing
import Foundation
@testable import CommonNetwork

struct URLSessionHTTPClientTests {

    // MARK: - Helpers

    private struct TestResponse: Decodable, Equatable, Sendable {
        let id: Int
        let name: String
    }

    private static func makeClient(
        baseURL: URL = URL(string: "https://api.example.com")!,
        session: URLSession? = nil
    ) -> URLSessionHTTPClient {
        URLSessionHTTPClient(
            baseURL: baseURL,
            session: session ?? .shared
        )
    }

    // MARK: - Endpoint Tests

    @Test func endpoint_defaultValues() {
        let endpoint = Endpoint(path: "/test")

        #expect(endpoint.method == .get)
        #expect(endpoint.headers.isEmpty)
        #expect(endpoint.queryItems.isEmpty)
        #expect(endpoint.body == nil)
    }

    @Test func endpoint_withJSON_setsContentTypeAndBody() throws {
        struct Body: Encodable, Sendable {
            let name: String
        }

        let endpoint = try Endpoint.withJSON(
            path: "/create",
            method: .post,
            body: Body(name: "test")
        )

        #expect(endpoint.method == .post)
        #expect(endpoint.headers["Content-Type"] == "application/json")
        #expect(endpoint.body != nil)
    }

    // MARK: - NetworkError Tests

    @Test func networkError_descriptions() {
        #expect(NetworkError.invalidURL.errorDescription == "Invalid URL")
        #expect(NetworkError.unauthorized.errorDescription == "Unauthorized")
        #expect(NetworkError.noConnection.errorDescription == "No internet connection")
        #expect(NetworkError.serverError(statusCode: 500).errorDescription == "Server error (500)")
    }

    // MARK: - HTTPMethod Tests

    @Test func httpMethod_rawValues() {
        #expect(HTTPMethod.get.rawValue == "GET")
        #expect(HTTPMethod.post.rawValue == "POST")
        #expect(HTTPMethod.put.rawValue == "PUT")
        #expect(HTTPMethod.patch.rawValue == "PATCH")
        #expect(HTTPMethod.delete.rawValue == "DELETE")
    }
}
