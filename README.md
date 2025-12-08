# GraphQL Go Project with gqlgen

A simple GraphQL API built with Go using gqlgen, featuring CRUD operations for a users table in PostgreSQL.

## Prerequisites

- Go 1.24 or higher
- PostgreSQL database
- Database named `graphql` should exist

## Setup

1. **Install dependencies:**
   ```bash
   go mod download
   ```

2. **Configure database connection:**
   
   Edit `database/database.go` and update the connection string if needed:
   ```go
   connStr := "user=postgres password=Qwerty@12 dbname=graphql sslmode=disable host=localhost port=5432"
   ```
   
   Adjust the following as needed:
   - `user`: Your PostgreSQL username
   - `password`: Your PostgreSQL password
   - `host`: Database host (default: localhost)
   - `port`: Database port (default: 5432)

3. **Create the database:**
   ```sql
   CREATE DATABASE graphql;
   ```

4. **Run the server:**
   ```bash
   go run main.go
   ```

   The server will start on `http://localhost:8080`

## GraphQL Endpoints

- **GraphQL Playground:** `http://localhost:8080/`
- **GraphQL API:** `http://localhost:8080/query` (POST requests)
- **GraphQL (alternative):** `http://localhost:8080/graphql` (POST requests)

## Available Operations

### Queries

1. **Get a single user:**
   ```graphql
   query {
     user(id: "1") {
       id
       name
       email
       age
       created_at
     }
   }
   ```

2. **Get all users:**
   ```graphql
   query {
     users {
       id
       name
       email
       age
       created_at
     }
   }
   ```

### Mutations

1. **Create a user (POST):**
   ```graphql
   mutation {
     createUser(name: "John Doe", email: "john@example.com", age: 30) {
       id
       name
       email
       age
       created_at
     }
   }
   ```

2. **Update a user (PUT):**
   ```graphql
   mutation {
     updateUser(id: "1", name: "Jane Doe", email: "jane@example.com", age: 25) {
       id
       name
       email
       age
       created_at
     }
   }
   ```

3. **Delete a user (DELETE):**
   ```graphql
   mutation {
     deleteUser(id: "1") {
       id
       name
       email
       age
       created_at
     }
   }
   ```

## Testing with cURL

### Create User (POST)
```bash
curl -X POST http://localhost:8080/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { createUser(name: \"John Doe\", email: \"john@example.com\", age: 30) { id name email age } }"
  }'
```

### Get User (GET)
```bash
curl -X POST http://localhost:8080/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { user(id: \"1\") { id name email age } }"
  }'
```

### Get All Users
```bash
curl -X POST http://localhost:8080/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { users { id name email age } }"
  }'
```

### Update User (PUT)
```bash
curl -X POST http://localhost:8080/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { updateUser(id: \"1\", name: \"Jane Doe\", email: \"jane@example.com\") { id name email age } }"
  }'
```

### Delete User (DELETE)
```bash
curl -X POST http://localhost:8080/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { deleteUser(id: \"1\") { id name email } }"
  }'
```

## Project Structure

```
graphql/
├── main.go                    # Entry point and server setup
├── go.mod                     # Go dependencies
├── gqlgen.yml                 # gqlgen configuration
├── database/
│   └── database.go            # Database connection and table creation
├── models/
│   └── user.go               # User model with database conversion helpers
├── graphql/
│   ├── schema.graphqls        # GraphQL schema definition
│   ├── generated/             # Generated GraphQL code (auto-generated)
│   │   └── generated.go
│   ├── models/                # Generated models (auto-generated)
│   │   └── models_gen.go
│   ├── resolver.go            # Resolver struct
│   └── schema.resolvers.go    # Resolver implementations
```

## Regenerating Code

If you modify the GraphQL schema (`graphql/schema.graphqls`), regenerate the code:

```bash
go run github.com/99designs/gqlgen generate
```

## Notes

- The `users` table is automatically created when the server starts
- All fields except `id` and `created_at` can be updated
- The `age` field is optional
- Email must be unique
- GraphQL IDs are strings, but stored as integers in the database (conversion handled automatically)
- This project uses gqlgen for type-safe GraphQL code generation
# itinerary-admin-backend-gql
# itinerary-admin-backend-gql
