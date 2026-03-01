import Foundation
import CoreData

/// Protocol for feature-specific sync logic.
///
/// Each feature registers a SyncHandler that knows how to push
/// pending local changes to the remote API and pull remote changes.
public protocol SyncHandler: Sendable {
    /// A unique identifier for this handler (e.g., "foodEntries", "workouts").
    var entityName: String { get }

    /// Push all pending local changes to the remote.
    func pushPendingChanges(context: NSManagedObjectContext) async throws

    /// Pull latest changes from the remote and merge into Core Data.
    func pullRemoteChanges(context: NSManagedObjectContext) async throws
}
