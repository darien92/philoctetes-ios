# Philoctetes iOS - Development Guidelines

## Architecture: MVI/Redux + Clean Architecture

### Store Pattern (MVI/Redux)

Every feature screen has a `Store<State, Action, Effect>` subclass (from `CommonDomain`):

- **State**: An `Equatable & Sendable` struct with all view state. Never optional when a default makes sense.
- **Action**: An enum of all user intents and internal events (e.g., `.onAppear`, `.loaded(Data)`, `.failed(String)`).
- **Effect**: An enum of one-time events for navigation/alerts (e.g., `.navigateToDetail`, `.showError`).
- **`reduce(_:_:)`**: Pure synchronous state mutation. No async, no side effects, no `self` access beyond state.
- **`handleSideEffects(_:)`**: Async work (API calls, DB reads). Calls `send()` with result actions and `emit()` for effects.
- Call stores "Stores", not "ViewModels". File naming: `DailyIntakeStore.swift`, not `DailyIntakeViewModel.swift`.

### Clean Architecture Layers

```
Domain → Data → Presentation
```

- **Domain**: Entities (plain structs), use case protocols, repository protocols. Lives in the Interface target.
- **Data**: Repository implementations, remote/local data sources, DTOs, mappers. Lives in the Feature target.
- **Presentation**: Stores, Views, Coordinators. Lives in the Feature target.

Never import Data types in Presentation. Stores depend on use case protocols only.

### Interface + Implementation Split

Each feature is a local SPM package with two library targets:

- `*Interface` — public protocols and entities. Other features depend on this.
- `*Feature` — internal implementations. Only the main app target imports this.

Rules:
- Feature implementations may depend on other features' **interfaces** (never implementations).
- Feature interfaces depend only on common modules (primarily `CommonDomain`).
- Common modules (`CommonDomain`, `CommonUI`, `CommonNetwork`, `CommonPersistence`) have no feature dependencies.

### Protocol-Based DI (Factory)

- Every dependency must have a protocol. Use constructor injection.
- Register in Factory containers within each feature's `DI/` directory.
- The main app's `AppContainer.swift` wires all feature containers.
- In tests, use `Container.shared.reset()` and `.register { MockImpl() }` for overrides.

### Coordinator Navigation

- Views never navigate directly. Navigation decisions flow through Effects → Coordinator.
- Base `Coordinator` class in `CommonDomain`. Feature coordinators in Feature targets.
- Coordinators own a `NavigationPath` and expose methods like `showLogFood()`, `showDetail(id:)`.

### Offline-First (Core Data)

- **Reads**: Always from Core Data. Background refresh from API when online.
- **Creates/Updates**: Save to Core Data with `syncStatus = .pendingUpload`. Push in background if online.
- **Deletes**: Soft delete (`syncStatus = .pendingDeletion`) if previously synced. Hard delete if never synced.
- Core Data model (`.xcdatamodeld`) lives in the main app target.
- Managed objects use `*MO` suffix (e.g., `FoodEntryMO`).
- Every syncable entity has: `remoteId`, `syncStatusRaw`, `lastModifiedAt`.

## Naming Conventions

| Item | Convention | Example |
|---|---|---|
| SPM interface target | `*Interface` | `CalorieTrackingInterface` |
| SPM implementation target | `*Feature` | `CalorieTrackingFeature` |
| Store classes | `*Store` | `DailyIntakeStore` |
| Use case protocols | `*UseCaseProtocol` | `LogFoodEntryUseCaseProtocol` |
| Repository protocols | `*RepositoryProtocol` | `FoodEntryRepositoryProtocol` |
| Core Data managed objects | `*MO` | `FoodEntryMO` |
| DTOs | `*DTO` | `FoodEntryDTO` |
| Mappers | `*Mapper` | `FoodEntryMapper` |
| DI containers | `*Container` | `CalorieTrackingContainer` |
| Coordinators | `*Coordinator` | `CalorieTrackingCoordinator` |

## File Organization

```
FeaturePackage/
├── Sources/
│   ├── FeatureInterface/          # Public API
│   │   ├── Entities/              # Domain models (structs)
│   │   ├── *RepositoryProtocol.swift
│   │   └── *UseCaseProtocol.swift
│   └── FeatureFeature/            # Internal implementation
│       ├── Domain/UseCases/       # Use case implementations
│       ├── Data/
│       │   ├── Repositories/      # Repository implementations
│       │   ├── DataSources/       # Remote + Local data sources
│       │   ├── DTOs/              # Network DTOs
│       │   └── Mappers/           # DTO ↔ Domain mappers
│       ├── Presentation/
│       │   ├── Coordinator/       # Navigation coordinator + routes
│       │   ├── Stores/            # MVI stores
│       │   └── Views/             # SwiftUI views
│       └── DI/                    # Factory container extensions
└── Tests/
```

## Testing

- Annotate protocols with `/// @mockable` for Mockolo auto-generation.
- Test reducers as pure functions: given `(state, action)` → assert new state.
- Test side effects by injecting mock use cases into stores.
- Test use cases by injecting mock repositories.
- Test repositories by injecting mock data sources.
- Use in-memory `PersistenceController(inMemory: true)` for Core Data tests.
- Use `URLProtocol` subclass for network integration tests.
- Use Factory's `.register {}` in `setUp()` and `Container.shared.reset()` in `tearDown()`.

## Build System

- Swift tools version: 6.1
- Deployment target: iOS 26
- Package manager: SPM (local packages under `Packages/`)
- All packages use `platforms: [.iOS(.v26)]`

## Common Modules

- **CommonDomain**: `Store` base class, `LoadingState`, `DomainError`, `Coordinator`
- **CommonUI**: Design system — `PhilColors`, `PhilTypography`, `PhilSpacing`, shared components (`PhilButton`, `PhilCard`, `PhilTextField`, `PhilLoadingView`, `PhilErrorView`, `PhilEmptyStateView`)
- **CommonNetwork**: `HTTPClientProtocol`, `URLSessionHTTPClient`, `Endpoint`, `NetworkMonitor`, `TokenProviderProtocol`
- **CommonPersistence**: `PersistenceController`, `SyncCoordinator`, `SyncState`, `SyncHandler`, `SyncableEntity`
