import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
//    Setup Database Configuration
    
    let databaseConfig = PostgreSQLDatabaseConfig (hostname: "localhost", port: 5432, username: "studentuser", database: "studentdb")

    // Configure a SQLite database
    let postgre = PostgreSQLDatabase(config: databaseConfig)
    
//    Register the configured database
    var databases = DatabasesConfig()
    databases.add(database: postgre, as: .psql)
    services.register(databases)
//
//    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Academy_Guys.self, database: .psql)
    migrations.add(model: Category.self, database: .psql)
    migrations.add(model: Collab.self, database: .psql)
    migrations.add(model: Event.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: UserEventPivot.self, database: .psql)
    migrations.add(model: CollabCategoryPivot.self, database: .psql)
//    migrations.add(model: Todo.self, database: .sqlite)
    services.register(migrations)
}
