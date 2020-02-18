//
//  CollabController.swift
//  App
//
//  Created by Marco Longobardi on 17/02/2020.
//

import Vapor
import FluentPostgreSQL
import JWT

struct CollabRequest: Content {
    var categoryId: Int
    var date: Date
    var durationHour: Int
}

//struct temp: Content {
//    var categoryId: Int
//    var collabId: Int
//}

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
    
    func getCollabForActivity(_ req: Request) throws -> Future<[Collab]> {
        
        return try authController.isUserAuthenticated(req).flatMap { isAuthenticated in
            if isAuthenticated {
                
                return try req.content.decode(CollabRequest.self).flatMap { collabRequest in
                    
                    return Category.query(on: req).filter(\.id == collabRequest.categoryId).all().flatMap { suggestedCollabs in
                        if suggestedCollabs.count > 0 {
                            
                            return try suggestedCollabs[0].collabs.query(on: req).all().flatMap { collabs in
                                if collabs.count > 0 {
                                    
                                    let advancedDate = Date(timeInterval: TimeInterval(collabRequest.durationHour * 3600), since: collabRequest.date)
                                    
                                    return Event.query(on: req).group(.or) {
                                        $0.filter(\.event_date >= collabRequest.date).filter(\.event_date <= advancedDate)
                                    }.all().map { events in
                                        var freeCollabs = collabs
                                        
                                        for event in events {
                                            freeCollabs.removeAll(where: { $0.id == event.collab_id })
                                        }
                                        
                                        return freeCollabs
                                    }
                                }
                                
                                throw Abort(.badRequest, reason: "ciao")
                            }
                        }
                        
                        throw Abort(.badRequest, reason: "Category not found :(")
                    }
                }
            }
            
            throw Abort(.unauthorized)
        }
    }
    
//    func associateCollabCategory(_ req: Request) throws -> Future<HTTPStatus> {
//        try req.content.decode(temp.self).flatMap { request in
//            Collab.find(request.collabId, on: req).flatMap { collab in
//                Category.find(request.categoryId, on: req).map { category in
//                    try CollabCategoryPivot(collab!, category!).save(on: req)
//
//                    return HTTPStatus.ok
//                }
//            }
//        }
//    }
}
