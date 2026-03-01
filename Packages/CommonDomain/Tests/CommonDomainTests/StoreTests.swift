import Testing
import Foundation
@testable import CommonDomain

@MainActor
struct StoreTests {

    // MARK: - Test Store

    @Observable
    final class CounterStore: Store<CounterStore.State, CounterStore.Action, CounterStore.Effect> {
        struct State: Equatable, Sendable {
            var count = 0
            var isLoading = false
        }

        enum Action: Sendable {
            case increment
            case decrement
            case reset
            case loadAsync
            case loaded(Int)
            case requestNavigation
        }

        enum Effect: Sendable {
            case navigateToDetail
        }

        override func reduce(_ state: inout State, _ action: Action) {
            switch action {
            case .increment: state.count += 1
            case .decrement: state.count -= 1
            case .reset: state.count = 0
            case .loadAsync: state.isLoading = true
            case .loaded(let value): state.count = value; state.isLoading = false
            case .requestNavigation: break
            }
        }

        override func handleSideEffects(_ action: Action) async {
            switch action {
            case .requestNavigation:
                emit(.navigateToDetail)
            default:
                break
            }
        }
    }

    // MARK: - Reducer Tests

    @Test func reduce_increment_increasesCount() {
        let store = CounterStore(initialState: .init())

        store.send(.increment)

        #expect(store.state.count == 1)
    }

    @Test func reduce_decrement_decreasesCount() {
        let store = CounterStore(initialState: .init(count: 5))

        store.send(.decrement)

        #expect(store.state.count == 4)
    }

    @Test func reduce_reset_setsCountToZero() {
        let store = CounterStore(initialState: .init(count: 42))

        store.send(.reset)

        #expect(store.state.count == 0)
    }

    @Test func reduce_multipleActions_appliesSequentially() {
        let store = CounterStore(initialState: .init())

        store.send(.increment)
        store.send(.increment)
        store.send(.increment)
        store.send(.decrement)

        #expect(store.state.count == 2)
    }

    @Test func reduce_loadAsync_setsLoading() {
        let store = CounterStore(initialState: .init())

        store.send(.loadAsync)

        #expect(store.state.isLoading)
    }

    @Test func reduce_loaded_updatesCountAndClearsLoading() {
        let store = CounterStore(initialState: .init(isLoading: true))

        store.send(.loaded(99))

        #expect(store.state.count == 99)
        #expect(!store.state.isLoading)
    }

    // MARK: - Effect Tests

    @Test func effect_requestNavigation_emitsNavigateEffect() async {
        let store = CounterStore(initialState: .init())

        store.send(.requestNavigation)

        var receivedEffect: CounterStore.Effect?
        for await effect in store.effects {
            receivedEffect = effect
            break
        }

        #expect(receivedEffect == .navigateToDetail)
    }
}
