//
//  Academy_Guys.swift
//  App
//
//  Created by Marco Longobardi on 13/02/2020.
//

import Vapor
import FluentPostgreSQL


final class Token: PostgreSQLModel {
    var id: Int?
    var token_string: String
    init(token_string: String) {
        self.token_string = token_string
    }
}


extension Token: Migration {}

extension Token: Content{}

extension Token: Parameter {}
