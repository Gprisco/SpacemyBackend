//
//  CollabCategoryPivot.swift
//  App
//
//  Created by Marco Longobardi on 14/02/2020.
//

import FluentPostgreSQL
import Foundation

final class CollabCategoryPivot: PostgreSQLUUIDPivot {
    var id: UUID?
    
    var collabID: Collab.ID
    var categoryID: Category.ID
    
    typealias Left = Collab
    typealias Right = Category
    
    static let leftIDKey: LeftIDKey = \.collabID
    static let rightIDKey: RightIDKey = \.categoryID
    
    init (_ collab:Collab, _ category: Category) throws {
        self.collabID = try collab.requireID()
        self.categoryID = try category.requireID()
    }
}

extension CollabCategoryPivot: Migration{
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on:connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.collabID, to: \Collab.id, onDelete: .cascade)
            builder.reference(from: \.categoryID, to: \Category.id, onDelete: .cascade)
        }
    }
}
extension CollabCategoryPivot: ModifiablePivot{}

