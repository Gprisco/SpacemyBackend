//
//  EventController.swift
//  App
//
//  Created by Giovanni Prisco on 17/02/2020.
//

import Vapor
import FluentPostgreSQL
import JWT

final class EventController {
    let authController = AuthController()
    
    func getEvents(_ req: Request) throws -> Future<[Event]> {
        return try authController.isUserAuthenticated(req).flatMap { isAuthenticated in
            if isAuthenticated {
                return Event.query(on: req).filter(\.event_date >= Date()).filter(\.category_id != 2).all()
            }
            
            throw Abort(.unauthorized)
        }
    }
    
    func createEvent(_ req: Request) throws -> Future<Event> {
        return try authController.isUserAuthenticated(req).flatMap { isAuthenticated in
            if isAuthenticated {
                return try req.content.decode(Event.self).flatMap { event in
                    return event.save(on: req).map { event in
                        let user = try JWT<UserPayload>(from: req.http.headers.bearerAuthorization!.token, verifiedUsing: .hs256(key: self.authController.secretKey))
                        
                        User.find(user.payload.id, on: req).map { user in
                            try UserEventPivot(user!, event).save(on: req)
                        }
                        
                        return event
                    }
                    
                }
            }
            
            throw Abort(.unauthorized)
        }
    }
    
    func getEvent(_ req: Request) throws -> Future<Event> {
        return try authController.isUserAuthenticated(req).flatMap { isAuthenticated in
            if isAuthenticated {
                return try req.parameters.next(Event.self)
            }
            
            throw Abort(.unauthorized)
        }
    }
    
    func participate(_ req: Request) throws -> Future<HTTPStatus> {
        return try authController.isUserAuthenticated(req).flatMap { isAuthenticated in
            if isAuthenticated {
                let user = try JWT<UserPayload>(from: req.http.headers.bearerAuthorization!.token, verifiedUsing: .hs256(key: self.authController.secretKey))
                
                return try req.parameters.next(Event.self).map { event in
                    User.find(user.payload.id, on: req).map { user in
                        try UserEventPivot(user!, event).save(on: req)
                    }
                    
                    return HTTPStatus.ok
                }
            }
            
            throw Abort(.unauthorized)
        }
    }
}
