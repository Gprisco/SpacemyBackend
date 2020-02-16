//
//  auth.controller.swift
//  App
//
//  Created by Giovanni Prisco on 16/02/2020.
//

import FluentPostgreSQL
import Vapor
import Crypto

struct RegisterAcademyGuy: Content {
    var identifier: Int
    var password: String
}

final class AuthController {
    func register(_ req: Request) throws -> Future<HTTPStatus> {
        
        //Decode the request, check if the request is from an academy guy by looking for his reg.id
        try req.content.decode(RegisterAcademyGuy.self).flatMap { academyGuy in
            let foundAcademyGuy = Academy_Guys.query(on: req).filter(\.identifier == academyGuy.identifier).all()
            
            return foundAcademyGuy.map { foundAcademyGuy in
                
                //If the guy is from the academy, continue with the registration
                if foundAcademyGuy.count > 0 {
                    do {
                        let hash = try BCrypt.hash(academyGuy.password, cost: 4)
                        
                        let newUser = User(identifier: foundAcademyGuy[0].identifier, name: foundAcademyGuy[0].name, surname: foundAcademyGuy[0].surname, password: hash)
                        
                        newUser.save(on: req)
                        
                        return HTTPStatus.ok
                        
                    } catch {
                        return HTTPStatus.internalServerError
                    }
                }
                
                return HTTPStatus.notAcceptable
            }
        }
    }    
}
