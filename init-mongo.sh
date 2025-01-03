#!/bin/bash

# Check if required environment variables are set
if [ -z "$MONGO_INITDB_ROOT_USERNAME" ] || [ -z "$MONGO_INITDB_ROOT_PASSWORD" ] || [ -z "$MONGO_INITDB_DATABASE" ]; then
  echo "Error: Missing required environment variables."
  echo "Ensure MONGO_INITDB_ROOT_USERNAME, MONGO_INITDB_ROOT_PASSWORD, and MONGO_INITDB_DATABASE are set."
  exit 1
fi

SEED_ROLES="['user:list', 'user:create', 'user:delete']"

# Wait for MongoDB to start
until mongosh --eval "print(\"waited for connection\")"; do
  echo "Waiting for MongoDB to start..."
  sleep 2
done

# Create a new user
mongosh <<EOF
use auth;
db.createUser({
  user: "$MONGO_INITDB_ROOT_USERNAME",
  pwd: "$MONGO_INITDB_ROOT_PASSWORD",
  roles: [
    { role: "readWrite", db: "$MONGO_INITDB_DATABASE" },
    { role: "readWrite", db: "$MONGO_AUTH_DATABASE" }
  ]
});

db.users.insertOne({
  name: "$ADMIN_USER",
  key: "$ADMIN_API_KEY",
  roles: [
    "user:list",
    "user:create",
    "user:delete"
  ]
});
print("Seed user added to Admin 'users' collection");
print("Application user created successfully");

use $MONGO_INITDB_DATABASE;
db.users.insertOne({
  name: "$ADMIN_USER",
  key: "$ADMIN_API_KEY",
  roles: [
    "user:list",
    "user:create",
    "user:delete"
  ]
});

print("Seed user added to App Data 'users' collection")l
EOF