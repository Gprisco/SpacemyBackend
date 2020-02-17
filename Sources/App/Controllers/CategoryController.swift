//
//  CategoryController.swift
//  App
//
//  Created by Marco Longobardi on 17/02/2020.
//

import Vapor
import FluentPostgreSQL
import JWT

final class CategoryController {
    let authController = AuthController()
    
    func getCategories(_ req: Request) throws -> Future<[Category]> {
        return try authController.isUserAuthenticated(req).flatMap { isAuthenticated in
            if isAuthenticated {
                return Category.query(on: req).all()
            }
            
            throw Abort(.unauthorized)
        }
    }
    
    func getCategory(_ req: Request) throws -> Future<Category> {
        return try authController.isUserAuthenticated(req).flatMap { isAuthenticated in
            if isAuthenticated {
                return try req.parameters.next(Category.self)
            }
            
            throw Abort(.unauthorized)
        }
    }
    
}
