import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    ///Authentication routes
    let authController = AuthController()

    router.post("register", use: authController.register)
    router.post("login", use: authController.login)
    router.delete("logout", use: authController.logout)
    
    ///Event routes
    let eventController = EventController()
    
    router.get("events", use: eventController.getEvents)
    router.get("events", Event.parameter, use: eventController.getEvent)
    router.post("events/create", use: eventController.createEvent)
}
