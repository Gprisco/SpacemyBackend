//
//  AuthController.swift
//  App
//
//  Created by Giovanni Prisco on 16/02/2020.
//

import FluentPostgreSQL
import JWT
import Vapor
import Crypto

let secretKey = "superS3cr3tK3yw0rD"
let hashRounds = 5

struct UserRequest: Content {
    var identifier: Int
    var password: String
}

struct UserPayload: JWTPayload {
    var identifier: Int
    var name: String
    var surname: String
    
    func verify(using signer: JWTSigner) throws {
        //code
    }
}

final class AuthController {
    func register(_ req: Request) throws -> Future<HTTPStatus> {
        
        //Decode the request, check if the request is from an academy guy by looking for his reg.id
        try req.content.decode(UserRequest.self).flatMap { academyGuy in
            let foundAcademyGuy = Academy_Guys.query(on: req).filter(\.identifier == academyGuy.identifier).all()
            
            let existingUser = User.query(on: req).filter(\.identifier == academyGuy.identifier).all()
            
            return foundAcademyGuy.flatMap { foundAcademyGuy in
                
                return existingUser.map { foundUser in
                    
                    //If the guy is from the academy, continue with the registration
                    if foundAcademyGuy.count > 0 && foundUser.count == 0 {
                        do {
                            let hash = try BCrypt.hash(academyGuy.password, cost: hashRounds)
                            
                            let newUser = User(identifier: foundAcademyGuy[0].identifier, name: foundAcademyGuy[0].name, surname: foundAcademyGuy[0].surname, password: hash)
                            
                            newUser.save(on: req)
                            
                            return HTTPStatus.ok
                            
                        } catch {
                            return HTTPStatus.internalServerError
                        }
                    }
                    
                    throw Abort(.unauthorized)
                }
            }
        }
    }
    
    func login(_ req: Request) throws -> Future<String> {
        try req.content.decode(UserRequest.self).flatMap { user in
            let foundUser = User.query(on: req).filter(\.identifier == user.identifier).all()
            
            return foundUser.map { foundUser in
                if foundUser.count > 0 {
                    
                    //Check if the password corresponds to its hash
                    let isValid = try BCrypt.verify(user.password, created: foundUser[0].password)
                    
                    if isValid {
                        let payload = UserPayload(identifier: foundUser[0].identifier, name: foundUser[0].name, surname: foundUser[0].surname)
                        
                        let token = try String(data: JWT(payload: payload).sign(using: .hs256(key: secretKey)), encoding: .utf8) ?? ""
                        
                        if token != "" {
                            Token(token_string: token).save(on: req)
                        }
                        
                        return token
                    }
                }
                
                throw Abort(.unauthorized)
            }
        }
    }
    
    func logout(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let token = req.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        
        let foundToken = Token.query(on: req).filter(\.token_string == token.token).all()
        
        return foundToken.flatMap { token in
            if token.count > 0 {
                return token[0].delete(on: req).map { deleted in
                    print(deleted)
                    
                    return HTTPStatus.ok
                }
            }
            
            throw Abort(.unauthorized)
        }
    }
}
