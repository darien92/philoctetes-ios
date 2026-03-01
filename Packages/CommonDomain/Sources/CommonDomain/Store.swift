import Foundation
import Observation

/// Base MVI/Redux Store with unidirectional data flow.
///
/// - View sends `Action` → `reduce` produces new `State` → View re-renders
/// - One-time events (navigation, alerts) are emitted as `Effect`
///
/// Subclasses override `reduce(_:_:)` for pure state mutations
/// and `handleSideEffects(_:)` for async work.
@Observable
@MainActor
open class Store<State: Equatable & Sendable, Action: Sendable, Effect: Sendable> {
    public private(set) var state: State

    private let _effects: AsyncStream<Effect>.Continuation
    public let effects: AsyncStream<Effect>

    public init(initialState: State) {
        self.state = initialState
        var cont: AsyncStream<Effect>.Continuation!
        self.effects = AsyncStream { cont = $0 }
        self._effects = cont
    }

    /// Pure reducer: synchronous state mutation. Override in subclasses.
    open func reduce(_ state: inout State, _ action: Action) {}

    /// Side effects: async work triggered by actions. Override in subclasses.
    open func handleSideEffects(_ action: Action) async {}

    /// Dispatch an action: reduce synchronously, then run side effects.
    public func send(_ action: Action) {
        reduce(&state, action)
        Task { [weak self] in
            await self?.handleSideEffects(action)
        }
    }

    /// Emit a one-time effect for the coordinator/view to handle.
    public func emit(_ effect: Effect) {
        _effects.yield(effect)
    }
}
