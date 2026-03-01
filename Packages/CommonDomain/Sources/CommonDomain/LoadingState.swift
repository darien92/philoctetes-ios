import Foundation

/// Generic loading state for any async operation.
public enum LoadingState<T: Equatable & Sendable>: Equatable, Sendable {
    case idle
    case loading
    case loaded(T)
    case failed(String)

    public var value: T? {
        if case .loaded(let v) = self { return v }
        return nil
    }

    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    public var error: String? {
        if case .failed(let msg) = self { return msg }
        return nil
    }
}
