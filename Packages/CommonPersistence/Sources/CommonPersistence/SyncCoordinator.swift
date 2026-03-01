import Foundation
import CoreData
import Observation

/// Orchestrates offline-first sync across all registered feature handlers.
///
/// Sync triggers:
/// - App foreground
/// - Connectivity change (offline → online)
/// - Periodic timer
/// - Manual request
@Observable
@MainActor
public final class SyncCoordinator {
    public private(set) var syncState: SyncState = .idle

    private var handlers: [SyncHandler] = []
    private let persistenceController: PersistenceController
    private var syncTask: Task<Void, Never>?

    public init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }

    /// Register a feature's sync handler.
    public func register(handler: SyncHandler) {
        handlers.append(handler)
    }

    /// Trigger a full sync cycle: push pending, then pull remote.
    public func sync() {
        switch syncState {
        case .idle, .failed, .completed:
            break
        case .syncing:
            return
        }

        syncTask = Task { [weak self] in
            await self?.performSync()
        }
    }

    /// Cancel any in-flight sync.
    public func cancelSync() {
        syncTask?.cancel()
        syncTask = nil
        syncState = .idle
    }

    // MARK: - Private

    private func performSync() async {
        syncState = .syncing(progress: 0)
        let total = Double(handlers.count * 2) // push + pull per handler
        var completed = 0.0

        let context = persistenceController.newBackgroundContext()

        do {
            // Phase 1: Push all pending local changes
            for handler in handlers {
                try Task.checkCancellation()
                try await handler.pushPendingChanges(context: context)
                completed += 1
                syncState = .syncing(progress: completed / total)
            }

            // Phase 2: Pull all remote changes
            for handler in handlers {
                try Task.checkCancellation()
                try await handler.pullRemoteChanges(context: context)
                completed += 1
                syncState = .syncing(progress: completed / total)
            }

            syncState = .completed(Date())
        } catch is CancellationError {
            syncState = .idle
        } catch {
            syncState = .failed(error.localizedDescription)
        }
    }
}
