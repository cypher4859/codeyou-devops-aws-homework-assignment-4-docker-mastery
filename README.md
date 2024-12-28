## SpaceX API Homework Assignment

### **Objective:**
Students will containerize and orchestrate a SpaceX API application using Docker and Docker Compose.

---

### **Part 1: Writing the Dockerfile**

#### **Requirements:**
Write a `Dockerfile` that meets the following criteria:

1. **Base Image**:
   - Use `node:18-alpine`.

2. **Install Bash**:
   - Use Alpine's default package manager to install `bash` without using the cache.

3. **Environment Variables**:
   - Set `NODE_ENV` to `production` by default.

4. **Expose Port**:
   - Expose the default port that this app uses.
   - **hint**: You'll need to identify how this app executes and listens. Note that app execution will begin at `start.sh` and you'll have to dig. We're only concerned with how the server is running, not workers if we can help it.

5. **Create User and Group**:
   - Add a Linux user `spacex`.
   - Ensure `spacex` is part of a group also named `spacex` and that the user is a system user.
   - The group should also be a system group.

6. **Ensure `/app` Directory Ownership**:
   - Run Linux commands to ensure `/app` exists and is owned by the `spacex` user.

7. **Run Commands as `spacex` User**:
   - Use a Dockerfile keyword to execute all subsequent commands as `spacex`.
   - **hint**: Remember that by default you run all commands as root but if you switch to `spacex` user in the Dockerfile then you might see permission denys on some commands. Be mindful of ***when you should switch*** to the spacex user.

8. **Working Directory**:
   - Set the working directory to `/app`.

9. **Entry Point**:
   - Set the entry point to `/app/start.sh`.
   - **hint**: hmm...do you have the `start.sh` file?

10. **Copy Dependencies**:
    - Add the following line:
      ```dockerfile
      COPY --chown=spacex:spacex package.json package-lock.json /app/
      ```

11. **Install Production Dependencies**:
    - Run the `npm` command to install only production dependencies (`"dependencies"` in `package.json`).

12. **Copy All Files**:
    - Add the following as the last line of the Dockerfile:
      ```dockerfile
      COPY --chown=spacex:spacex . .
      ```

13. **No CMD Statement**:
    - Do not include a `CMD` statement in this Dockerfile.

---

### **Part 2: Writing the `docker-compose.yml` File**

#### **Requirements:**
The docker-compose.yml should use version `3.9`.

1. **Service: `app`**
   - Build from the `Dockerfile` in the current working directory.
   - Publish the port exposed in the Dockerfile (`6673`).
   - Specify a volume targeting `/app/node_modules`.
   - There are a series of environment variables that the spaceX-API makes use of in order to connect to the mongo database. Identify these enviroment variables and make sure they have values set in this service. Remember that these environment variables will be used to allow the app to connect to Mongo.
        - **HINT**: NodeJS typically uses `process.env` to get environment varaibles.
   - Set the following environment variables to match the `mongo` service:
     - `DB_HOST`
     - `DB_NAME`
     - `DB_USERNAME`
     - `DB_PASSWORD`
   - Ensure the `app` service waits for the `mongo` service to start.

2. **Service: `mongo`**
   - Use the image `mongo:6.0`.
   - Set the container name to `mongo`.
   - Make the default MongoDB port (`27017`) accessible.
   - Use a bind mount volume to ensure `./init-mongo.sh` is mounted at the appropriate location for MongoDB initialization. Refer to [MongoDB Docker Hub documentation](https://hub.docker.com/_/mongo).
   - Set the following environment variables:
     - `MONGO_INITDB_DATABASE`
     - `MONGO_INITDB_ROOT_USERNAME`
     - `MONGO_INITDB_ROOT_PASSWORD`

---

### **Deliverables:**
Students must provide the following to demonstrate successful completion of the assignment:

1. **Dockerfile**:
   - A screenshot of the completed Dockerfile.

2. **docker-compose.yml**:
   - A screenshot of the completed `docker-compose.yml` file.

3. **Running Services**:
   - A screenshot showing both services (`app` and `mongo`) running using `docker compose ps` or similar.

4. **Container Logs**:
   - Screenshots of the logs for both the `app` and `mongo` containers using `docker compose logs` or similar.

5. **Verification**:
   - Provide evidence (e.g., a screenshot of `curl` or browser) that the `app` service is accessible on the specified port.
   - **Hint**: Notice that nodejs handles routing via the `const router = new Router()` syntax. The syntax of the endpoint does work like:
      ```
      localhost:<PORT>/v4/<endpoint>
      localhost:<PORT>/latest/<endpoint>
      ```
      Where endpoint is the thing you're trying to interrogate.  
      Additionally, you may have noticed that all the admin endpoints expect an API key right? Well...**hint**: How does it actually know that your API key is correct or not? Who/what decides it's correct?

6. **BONUS (10pts)**:
    - Attempt to find a way to get admin access to the app. Beware of dinosaurs.
    - 10pts bonus for completion.
    - Partial points rewarded if you can identify how to do it even if you can't actually get access

7. **BONUS (5pts)**:
    - Implement a healthcheck in your Dockerfile and/or docker-compose.yml
    - **HINT**: There's javascript file in the project that already implements a healthcheck, you mainly need to configure Docker and your deployment to actually make use of it.
---
