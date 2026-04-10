# Troubleshooting

## Jenkins Won't Start

**Symptom**: `docker compose up` runs but Jenkins is not accessible at http://localhost:8080.

**Fix**: Wait 2-3 minutes — Jenkins takes time to initialize, install plugins, and apply configuration. Check the logs:

```bash
docker compose logs jenkins
```

Look for `Jenkins is fully up and running`.

## Agent Not Connecting

**Symptom**: The agent container keeps restarting or the agent shows "offline" in Jenkins.

**Fix**:

1. Check agent logs:

```bash
docker compose logs jenkins-agent
```

2. If you see "Jenkins not ready yet, retrying" — the agent is waiting for Jenkins. Give it time.

3. If you see "Could not retrieve agent secret" — the agent node might not be configured in Jenkins. Verify it exists: **Manage Jenkins** → **Nodes**.

4. Restart the agent:

```bash
docker compose restart jenkins-agent
```

## Port Already in Use

**Symptom**: `Error: bind: address already in use` when starting Docker Compose.

**Fix**: Something else is using port 8080, 8081, or 5000. Find and stop it:

```bash
# Find what's using a port (e.g., 8080)
lsof -i :8080

# Or change our ports in docker-compose.yml
# e.g., change "8080:8080" to "9080:8080"
```

## Docker Push Fails

**Symptom**: Pipeline fails at "Push to Registry" with an error about HTTPS or connection refused.

**Fix**: You need to configure Docker to allow our insecure local registry:

1. Open Docker Desktop → **Settings** → **Docker Engine**
2. Add to the JSON config:

```json
{
  "insecure-registries": ["localhost:5000"]
}
```

3. Click **Apply & Restart**

## Docker Socket Permission Denied

**Symptom**: Pipeline fails with `permission denied` when trying to build or run Docker commands.

**Fix**: The Jenkins agent needs access to the Docker socket. Check that the socket is mounted in `docker-compose.yml`:

```yaml
jenkins-agent:
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
```

On Linux, you may also need to add the jenkins user to the docker group inside the agent container.

## Out of Memory

**Symptom**: Builds fail randomly, containers crash, or Docker Desktop becomes unresponsive.

**Fix**: This environment needs ~4 GB RAM. In Docker Desktop:

1. Go to **Settings** → **Resources**
2. Increase memory to at least 4 GB
3. Click **Apply & Restart**

## Build Fails at Checkout

**Symptom**: "Could not read from remote repository" or "Failed to connect to github.com" error.

**Fix**: The pipeline clones the source code from the [address-book](https://github.com/jasoncalalang/address-book) repository on GitHub. Check:

1. Your machine has internet access — Jenkins fetches from `github.com`
2. The repo URL in `jenkins/jobs/seed.groovy` is reachable:

   ```bash
   curl -I https://github.com/jasoncalalang/address-book.git
   ```

3. If you changed the URL to point at a fork or private repo, make sure credentials are configured in Jenkins.

## Pipeline Runs But App Not Accessible

**Symptom**: Build succeeds but http://localhost:8081 doesn't work.

**Fix**:

1. Check if the container is running:

```bash
docker ps | grep address-book
```

2. If not running, check why it stopped:

```bash
docker logs address-book
```

3. Check the container is on the right network:

```bash
docker network inspect jenkins-net
```

## Reset Everything

If all else fails, tear everything down and start fresh:

```bash
docker compose down -v
docker stop address-book && docker rm address-book
docker compose up -d --build
```
