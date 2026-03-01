import Foundation
import Network
import Observation

/// Monitors network connectivity using NWPathMonitor.
@Observable
public final class NetworkMonitor: @unchecked Sendable {
    public private(set) var isConnected: Bool = true
    public private(set) var connectionType: ConnectionType = .unknown

    private let monitor: NWPathMonitor
    private let queue: DispatchQueue

    public enum ConnectionType: Sendable {
        case wifi
        case cellular
        case wiredEthernet
        case unknown
    }

    public init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue(label: "com.philoctetes.networkmonitor")
    }

    public func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            let connectionType = Self.resolveConnectionType(path)
            DispatchQueue.main.async {
                self?.isConnected = isConnected
                self?.connectionType = connectionType
            }
        }
        monitor.start(queue: queue)
    }

    public func stop() {
        monitor.cancel()
    }

    private static func resolveConnectionType(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) { return .wifi }
        if path.usesInterfaceType(.cellular) { return .cellular }
        if path.usesInterfaceType(.wiredEthernet) { return .wiredEthernet }
        return .unknown
    }
}
