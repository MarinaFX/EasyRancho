import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    func startMonitoring(_ completion: @escaping (NWPath) -> Void) {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            
            if path.status == .satisfied {
                completion(path)
            } else {
                completion(path)
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        DispatchQueue.global().async {
            self.monitor.start(queue: queue)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}