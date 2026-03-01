import CoreData

/// Manages the Core Data stack.
///
/// The `.xcdatamodeld` file lives in the main app target.
/// This controller is initialized with the model name and optional
/// in-memory flag for testing.
public final class PersistenceController: @unchecked Sendable {
    public let container: NSPersistentContainer

    /// Shared instance — initialized by the app at launch.
    public nonisolated(unsafe) static var shared: PersistenceController!

    public init(modelName: String = "Phil", inMemory: Bool = false, bundle: Bundle = .main) {
        guard let modelURL = bundle.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model '\(modelName)' from bundle")
        }

        container = NSPersistentContainer(name: modelName, managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    /// Create a background context for sync/write operations.
    public func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }
}
