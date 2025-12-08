//
//  EventRepositoryImpl.swift
//  TDData
//
//  Created by 승재 on 10/20/25.
//


import Foundation
import TDCore
import TDDomain

public struct EventRepositoryImpl: EventRepository {
    
    private let service: EventService
    
    public init(service: EventService) {
        self.service = service
    }
    
    public func fetchEvents() async throws -> [TDEvent] {
        try await service.fetchEvents().map { $0.convertToEvent() }
    }
    
    public func fetchEventDetails(eventId: Int) async throws -> TDEventDetail? {
        let detailList = try await service.fetchEventDetails(eventId: eventId).map { $0.convertToEventDetail() }
        return detailList.filter { $0.eventsId == eventId }.first
    }
    
    public func hasParticipated() async throws -> Bool {
        try await service.hasParticipated()
    }
    
    public func participate(socialId: Int, phone: String) async throws {
        try await service.participate(socialId: socialId, phone: phone)
    }
}
