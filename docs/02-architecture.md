# Architecture

## Services

This environment runs four Docker containers that work together:

```mermaid
graph TB
    subgraph "Docker Compose Environment"
        Jenkins[Jenkins Controller<br/>:8080]
        Agent[Jenkins Agent]
        Registry[Docker Registry<br/>:5000]
        App[Address Book App<br/>:8081]
    end

    You([Your Browser])
    You -->|"http://localhost:8080"| Jenkins
    You -->|"http://localhost:8081"| App
    Jenkins -->|"JNLP :50000"| Agent
    Agent -->|"docker push"| Registry
    Agent -->|"docker run"| App
    Registry -->|"docker pull"| Agent
```

### Jenkins Controller

The "brain" of the operation. It stores pipeline configurations, schedules builds, and presents the web UI. It does NOT run builds itself — it delegates that to the agent.

- **URL**: http://localhost:8080
- **Login**: admin / admin

### Jenkins Agent

A worker that executes build steps on behalf of the controller. Our agent has Java, Docker CLI, and Trivy installed so it can build, test, scan, and deploy the application.

### Docker Registry

A local image repository. When the pipeline builds a Docker image of the address book, it pushes the image here. During deployment, the image is pulled from this registry.

- **URL**: http://localhost:5000

### Address Book Application

The Spring Boot application deployed by the pipeline. After a successful build, you can access it and see the running application.

- **URL**: http://localhost:8081

## Network

All services share a Docker network called `jenkins-net`. This lets them communicate by container name (e.g., the agent can reach Jenkins at `http://jenkins:8080`).

## Data Flow During a Build

```mermaid
sequenceDiagram
    participant You
    participant Jenkins as Jenkins Controller
    participant Agent as Jenkins Agent
    participant Registry as Docker Registry
    participant App as Address Book

    You->>Jenkins: Click "Build Now"
    Jenkins->>Agent: Run pipeline steps
    Agent->>Agent: Checkout code
    Agent->>Agent: Build with Gradle
    Agent->>Agent: Run tests
    Agent->>Agent: Run code quality checks
    Agent->>Agent: Build Docker image
    Agent->>Agent: Scan image with Trivy
    Agent->>Registry: Push image
    Agent->>App: Stop old container
    Agent->>Registry: Pull new image
    Agent->>App: Start new container
    Agent->>App: Health check
    Agent->>Jenkins: Report success
    Jenkins->>You: Show green build
```

## Next

Continue to [Jenkins Basics](03-jenkins-basics.md) to learn how to navigate the Jenkins UI.
