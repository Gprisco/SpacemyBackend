//
//  Academy_Guys.swift
//  App
//
//  Created by Marco Longobardi on 13/02/2020.
//

import Vapor
import FluentPostgreSQL


final class Academy_Guys: PostgreSQLModel {
    var id: Int?
    var identifier: Int
    var name: String
    var surname: String
    init(identifier: Int, name: String, surname: String) {
        self.identifier = identifier
        self.name = name
        self.surname = surname
    }
}


extension Academy_Guys: Migration {}

extension Academy_Guys: Content{}

extension Academy_Guys: Parameter {}
