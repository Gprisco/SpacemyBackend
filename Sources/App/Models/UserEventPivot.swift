//
//  UserEventPivot.swift
//  App
//
//  Created by Marco Longobardi on 14/02/2020.
//


import FluentPostgreSQL
import Foundation

final class UserEventPivot: PostgreSQLUUIDPivot {
    var id: UUID?
    
    var userID: User.ID
    var eventID: Event.ID
    
    typealias Left = User
    typealias Right = Event
    
    static let leftIDKey: LeftIDKey = \.userID
    static let rightIDKey: RightIDKey = \.eventID
    
    init(_ user: User, _ event: Event) throws {
        self.userID = try user.requireID()
        self.eventID = try event.requireID()
    }
}

extension UserEventPivot: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on:connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.userID, to: \User.id, onDelete: .cascade)
            builder.reference(from: \.eventID, to: \Event.id, onDelete: .cascade)
        }
    }
}
