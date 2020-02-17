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
    router.get("events/participate", Event.parameter, use: eventController.participate)
    
    ///Category routes
    let categoryController = CategoryController()
    
    router.get("categories", use: categoryController.getCategories)
    router.get("categories", Category.parameter, use: categoryController.getCategory)
    
    ///Collab routes
    let collabController = CollabController()
    
    router.get("collabs",use: collabController.getCollabs)
    router.get("collabs", Collab.parameter, use: collabController.getCollab)
    router.get("suggestedCollabs", use: collabController.getCollabForActivity)
//    router.post("temp", use: collabController.associateCollabCategory)
}
