// MessageGroup.swift
// Copyright (c) 2026 Namdak Tonpa

// MessageGroup implements Multicast Topic 29 Reader/Writer for Tactical Chat communications
// See Skynet32 protocol specification.

import Foundation

actor MessageGroup {
    var topic: Int = 29
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
