
#!/bin/bash

# Configuration Jira
JIRA_BASE_URL="https://valueit7.atlassian.net"
JIRA_PROJECT="EMS"
JIRA_USER="valueit7@gmail.com"
JIRA_API_TOKEN="ATATT3xFfGF0XjfWhaDOj5Xh9M9X2VgMdui3Lp21Y4VQr4CUDsxGPO4XcLQZppECmZprRHycOPl8uS_NZ4vvmohIl30ZMvElUfBou-8RFjEIbF3WCTYZPkMD-3ZjIwxr09Z_7l65v2Lt-8BBOPZO3IUgVed9vzika0pYNkpluilyfwy5gRgaLRo=87575459"
OUTPUT_FILE="release_notes.md"
RELEASE_VERSION="Release 1.0.0"

# Récupération des tickets Jira
JQL_QUERY="project=$JIRA_PROJECT AND status=Done AND fixVersion=\"$RELEASE_VERSION\""
ENCODED_JQL=$(echo "$JQL_QUERY" | jq -sRr @uri)
URL="$JIRA_BASE_URL/rest/api/2/search?jql=$ENCODED_JQL"

echo "Fetching Jira issues for release $RELEASE_VERSION from: $URL"

# Effectuer la requête et afficher la réponse pour le debug
RESPONSE=$(curl -s -u "$JIRA_USER:$JIRA_API_TOKEN" -X GET -H "Content-Type: application/json" "$URL")

echo "Jira response:"
echo "$RESPONSE" | jq .

# Vérifier si la réponse contient des issues
if echo "$RESPONSE" | jq -e '.issues' >/dev/null; then
  echo "$RESPONSE" | jq -r '.issues[] | "- \(.key) (\(.fields.issuetype.name)) - \(.fields.summary)"' > $OUTPUT_FILE
  echo "Release notes generated for version $RELEASE_VERSION: $OUTPUT_FILE"
else
  echo "No issues found for release $RELEASE_VERSION."
  echo "No issues found for release $RELEASE_VERSION." > $OUTPUT_FILE
fi