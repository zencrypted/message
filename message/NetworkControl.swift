// MessageControl.swift
// Copyright (c) 2026 Namdak Tonpa

// MessageControl implements Multicast Topic 1 Reader/Writer for Service Control / Discovery
// See Skynet32 protocol specification.

import Foundation

actor MessageControl {
    var topic: Int = 1
    weak var service: MessageService?

    private var socket: CFSocket?
    private var isRunning = false

    init(service: MessageService) {
        self.service = service
    }

    func startListening() {
        guard !isRunning else { return }
        isRunning = true
        Task.detached { await self.runMulticastLoop() }
    }

    func runMulticastLoop() async {

    }
    
    func send(_ text: String, in conversation: Conversation) {

    }
    
    deinit {
    }
}
