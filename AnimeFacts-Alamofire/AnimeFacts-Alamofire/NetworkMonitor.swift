//
//  NetworkMonitor.swift
//  AnimeFacts-Alamofire
//
//  Created by Малиль Дугулюбгов on 18.01.2022.
//

import Network

final class NetworkMonitor {
    static var shared = NetworkMonitor()
    
    private var monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "Network")
    
    private(set) var isConnected: Bool = false
    
    init() {
        self.monitor = NWPathMonitor()
    }
    
    func startMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitor() {
        monitor.cancel()
    }
}
