//
//  CollabController.swift
//  App
//
//  Created by Marco Longobardi on 17/02/2020.
//

import Vapor
import FluentPostgreSQL
import JWT

final class CollabController {
    let authController = AuthController()
    
    func getCollabs(_ req: Request) throws -> Future<[Collab]> {
        return try authController.isUserAuthenticated(req).flatMap { isAuthenticated in
            if isAuthenticated {
                return Collab.query(on: req).all()
            }
            
            throw Abort(.unauthorized)
        }
    }
    
    func getCollab(_ req: Request) throws -> Future<Collab> {
        return try authController.isUserAuthenticated(req).flatMap { isAuthenticated in
            if isAuthenticated {
                return try req.parameters.next(Collab.self)
            }
            
            throw Abort(.unauthorized)
        }
    }
    
}
