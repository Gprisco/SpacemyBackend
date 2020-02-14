//
//  Academy_Guys.swift
//  App
//
//  Created by Marco Longobardi on 13/02/2020.
//

import Vapor
import FluentPostgreSQL


final class Event: PostgreSQLModel {
    var id: Int?
    var name: String
    var category_id: Int
    var creator_id: Int
    var collab_id: Int
    var event_data: Date
    init(category_id: Category.ID, name: String, creator_id: Int, event_data: Date, collabID: Collab.ID) {
        self.name = name
        self.category_id = category_id
        self.creator_id = creator_id
        self.event_data = event_data
        self.collab_id = collabID
    }
}



extension Event: Migration {
    static func prepare (
        on connection: PostgreSQLConnection
    )-> Future<Void>{
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from:\.category_id, to:\Category.id)
            builder.reference(from: \.collab_id, to: \Collab.id)
        }
    }
}

extension Event: Content{}

extension Event: Parameter {}
