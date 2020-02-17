//
//  Academy_Guys.swift
//  App
//
//  Created by Marco Longobardi on 13/02/2020.
//

import Vapor
import FluentPostgreSQL


final class Collab: PostgreSQLModel {
    var id: Int?
    var spots: Int
    
    var categories: Siblings<Collab, Category, CollabCategoryPivot> {
        return siblings()
    }
    
    init(spots: Int) {
        self.spots = spots
    }
}


extension Collab: Migration {}

extension Collab: Content{}

extension Collab: Parameter {}
