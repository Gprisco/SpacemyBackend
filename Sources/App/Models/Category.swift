//
//  Academy_Guys.swift
//  App
//
//  Created by Marco Longobardi on 13/02/2020.
//

import Vapor
import FluentPostgreSQL


final class Category: PostgreSQLModel {
    var id: Int?
    var name: String
    init(name: String) {
        self.name = name
    }
}


extension Category: Migration {}

extension Category: Content{}

extension Category: Parameter {}
