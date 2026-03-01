import Foundation

public final class URLSessionHTTPClient: HTTPClientProtocol {
    private let session: URLSession
    private let baseURL: URL
    private let tokenProvider: TokenProviderProtocol?
    private let decoder: JSONDecoder

    public init(
        baseURL: URL,
        tokenProvider: TokenProviderProtocol? = nil,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.tokenProvider = tokenProvider
        self.session = session
        self.decoder = decoder
    }

    public func request<T: Decodable & Sendable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {
        let urlRequest = try await buildRequest(for: endpoint)
        let (data, response) = try await perform(urlRequest)
        try validate(response)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }
    }

    public func request(endpoint: Endpoint) async throws {
        let urlRequest = try await buildRequest(for: endpoint)
        let (_, response) = try await perform(urlRequest)
        try validate(response)
    }

    // MARK: - Private

    private func buildRequest(for endpoint: Endpoint) async throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true)
        if !endpoint.queryItems.isEmpty {
            components?.queryItems = endpoint.queryItems
        }

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let tokenProvider {
            let token = try await tokenProvider.getToken()
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch let error as URLError where error.code == .notConnectedToInternet {
            throw NetworkError.noConnection
        } catch let error as URLError where error.code == .timedOut {
            throw NetworkError.timeout
        } catch {
            throw NetworkError.unknown(error.localizedDescription)
        }
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown("Invalid response type")
        }

        switch httpResponse.statusCode {
        case 200...299: return
        case 401: throw NetworkError.unauthorized
        case 403: throw NetworkError.forbidden
        case 404: throw NetworkError.notFound
        default: throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}
