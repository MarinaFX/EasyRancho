//
//  NetworkMonitor.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 14/10/21.
//

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
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
