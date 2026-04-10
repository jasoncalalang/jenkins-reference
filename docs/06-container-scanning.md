# Container Scanning

## Why Scan Container Images?

Container images are built from base images that contain operating system packages and libraries. These packages can have known security vulnerabilities (CVEs). If you deploy an image with a critical vulnerability, attackers could exploit it.

**Container scanning** automatically checks your images against vulnerability databases and alerts you before deployment.

## Trivy

Trivy is an open-source security scanner by Aqua Security. It scans container images, file systems, and code repositories for:

- Known vulnerabilities (CVEs) in OS packages and libraries
- Misconfigurations
- Exposed secrets

In our pipeline, Trivy runs after the Docker image is built:

```groovy
stage('Scan Image') {
    steps {
        sh "trivy image --format table -o trivy-report.txt ${IMAGE_TAG}"
        sh "trivy image --severity CRITICAL --exit-code 1 ${IMAGE_TAG}"
    }
}
```

The first command generates a human-readable report. The second command fails the build if any CRITICAL vulnerability is found.

## Severity Levels

| Severity | Meaning |
|---|---|
| CRITICAL | Actively exploitable, immediate risk |
| HIGH | Serious vulnerability, should be fixed soon |
| MEDIUM | Moderate risk |
| LOW | Minor risk |
| UNKNOWN | Not yet classified |

Our pipeline only fails on CRITICAL. In a real environment, you might also fail on HIGH.

## Reading the Report

After a build, check the Trivy report:

1. Go to the build page in Jenkins
2. Look for **trivy-report.txt** in the build artifacts
3. The report shows each vulnerability with its CVE ID, severity, package name, installed version, and fixed version

## Try It Yourself

1. Run a successful build and check the Trivy report artifact
2. In your fork of the [address-book](https://github.com/jasoncalalang/address-book) repo, edit `Dockerfile` and change the base image to an older, vulnerable version:

```dockerfile
FROM eclipse-temurin:17.0.1_12-jre-alpine
```

3. Commit and rebuild — watch Trivy fail the build
4. Change it back to `eclipse-temurin:21-jre-alpine` and rebuild to confirm it passes

## Next

Continue to [Deployment](07-deployment.md) to learn about the deployment process.
