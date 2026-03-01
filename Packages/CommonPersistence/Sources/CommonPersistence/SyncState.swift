import Foundation

/// Sync status for any offline-first entity.
public enum SyncStatus: Int16, Sendable {
    /// Synced with the remote server.
    case synced = 0
    /// Created or updated locally, pending upload.
    case pendingUpload = 1
    /// Marked for deletion locally, pending remote deletion.
    case pendingDeletion = 2
    /// Currently being synced.
    case syncing = 3
    /// Sync failed — will retry.
    case failed = 4
}

/// Overall sync state for the coordinator to report.
public enum SyncState: Equatable, Sendable {
    case idle
    case syncing(progress: Double)
    case completed(Date)
    case failed(String)
}
