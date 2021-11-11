import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    var status: NWPath.Status {
        path?.status ?? .requiresConnection
    }
    var path: NWPath?
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    var completions: [(NWPath) -> Void] = []
    
    private init() {
        
    }
    
    func startMonitoring(_ completion: @escaping (NWPath) -> Void) {
        if !completions.isEmpty {
            completions.append(completion)
            if let path = path {
                completion(path)
            }
            return
        }
        
        completions.append(completion)
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.path = path
            self?.isReachableOnCellular = path.isExpensive
            
            for completion in self?.completions ?? [] {
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
