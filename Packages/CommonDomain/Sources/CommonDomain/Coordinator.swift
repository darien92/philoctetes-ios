import SwiftUI

/// Base coordinator for managing navigation within a feature.
///
/// Each feature has its own Coordinator subclass that owns a `NavigationPath`
/// and handles routing based on effects from the Store.
@Observable
@MainActor
open class Coordinator {
    public var path = NavigationPath()

    public init() {}

    /// Push a hashable route onto the navigation stack.
    open func push<R: Hashable>(_ route: R) {
        path.append(route)
    }

    /// Pop the top route from the navigation stack.
    open func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Pop to the root of the navigation stack.
    open func popToRoot() {
        path = NavigationPath()
    }
}
