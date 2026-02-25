// MessagePeer.swift
// Copyright (c) Namdak Tonpa

// MessagePeer implements Multicast Topic 28 Reader/Writer for Peer-to-Peer communications
// See Skynet32 protocol specification.

import Foundation

#if canImport(UIKit)
import UIKit
#endif

actor MessagePeer {
    var topic: Int = 28
    weak var service: MessageService?
    private var socket: CFSocket?
    private let myIdentifier: String
    
    init(service: MessageService) {
        self.service = service
        self.myIdentifier = Self.deviceUniqueIdentifier()
    }
    
    func startListening() { Task { await self.runListeningLoop() } }
    
    private func runListeningLoop() async {
    }
    
    func send(_ text: String, to conversation: Conversation) {
    }
    
    static func deviceUniqueIdentifier() -> String {
        let name = ProcessInfo.processInfo.hostName
        
        #if canImport(UIKit)
        let vendorPart = UIDevice.current.identifierForVendor?.uuidString ?? ""
        #else
        let vendorPart = ""
        #endif
            
        if vendorPart.isEmpty { return name } else { return "\(vendorPart)-\(name)" }
    }
}
