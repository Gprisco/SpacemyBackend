//
//  Academy_Guys.swift
//  App
//
//  Created by Marco Longobardi on 13/02/2020.
//

import Vapor
import FluentPostgreSQL

final class User: PostgreSQLModel {
    var id: Int?
    var identifier: Int
    var name: String
    var surname: String
    var password: String
    
    var events: Siblings<User, Event, UserEventPivot> {
        return siblings()
    }
    
    init(identifier: Int, name: String, surname: String, password: String) {
        self.identifier = identifier
        self.name = name
        self.surname = surname
        self.password = password
    }
}

extension User: Migration {}

extension User: Content{}

extension User: Parameter {}
