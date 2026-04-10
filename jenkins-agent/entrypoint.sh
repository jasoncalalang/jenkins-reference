#!/bin/bash
set -e

JENKINS_URL="${JENKINS_URL:-http://jenkins:8080}"
JENKINS_USER="${JENKINS_USER:-admin}"
JENKINS_PASS="${JENKINS_PASS:-admin}"
JENKINS_AGENT_NAME="${JENKINS_AGENT_NAME:-docker-agent}"

echo "Waiting for Jenkins at ${JENKINS_URL}..."
until curl -sf -u "${JENKINS_USER}:${JENKINS_PASS}" "${JENKINS_URL}/api/json" >/dev/null 2>&1; do
    echo "  Jenkins not ready yet, retrying in 5s..."
    sleep 5
done
echo "Jenkins is ready."

echo "Fetching agent secret for '${JENKINS_AGENT_NAME}'..."
JENKINS_SECRET=$(curl -sf -u "${JENKINS_USER}:${JENKINS_PASS}" \
    "${JENKINS_URL}/computer/${JENKINS_AGENT_NAME}/slave-agent.jnlp" \
    | sed -n 's/.*<argument>\([a-f0-9]\{64\}\)<\/argument>.*/\1/p')

if [ -z "${JENKINS_SECRET}" ]; then
    echo "ERROR: Could not retrieve agent secret. Is the agent '${JENKINS_AGENT_NAME}' configured in Jenkins?"
    exit 1
fi

echo "Connecting agent '${JENKINS_AGENT_NAME}'..."
exec java -jar /usr/share/jenkins/agent.jar \
    -url "${JENKINS_URL}" \
    -name "${JENKINS_AGENT_NAME}" \
    -secret "${JENKINS_SECRET}" \
    -workDir "/home/jenkins/agent"
