import Foundation
import CoreData

/// Protocol for Core Data managed objects that support offline-first sync.
///
/// Every syncable entity must have:
/// - `remoteId`: The server-side ID (nil if created offline and not yet synced)
/// - `syncStatusRaw`: Int16 backing store for `SyncStatus`
/// - `lastModifiedAt`: Timestamp for conflict detection
public protocol SyncableEntity: NSManagedObject {
    var remoteId: String? { get set }
    var syncStatusRaw: Int16 { get set }
    var lastModifiedAt: Date? { get set }
}

extension SyncableEntity {
    public var syncStatus: SyncStatus {
        get { SyncStatus(rawValue: syncStatusRaw) ?? .synced }
        set { syncStatusRaw = newValue.rawValue }
    }

    public var needsSync: Bool {
        syncStatus == .pendingUpload || syncStatus == .pendingDeletion || syncStatus == .failed
    }
}
