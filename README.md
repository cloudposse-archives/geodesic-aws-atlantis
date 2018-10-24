# Atlantis Server with Fargate

## Quick Start

### Write secrets to Chamber

Atlantis will be invoked with chamber to expose the secrets as environment variables.

**IMPORTANT** Make sure to write the parameters to the same region as your ECS tasks.

```
# Allow atlantis to process `atlantis.yaml`
chamber write atlantis ATLANTIS_ALLOW_REPO_CONFIG true

# Set the log verbosity
chamber write atlantis ATLANTIS_LOG_LEVEL debug

# Set the listen port for atlantis
chamber write atlantis ATLANTIS_PORT 4141

# Set the atlantis webhook base URL
chamber write atlantis ATLANTIS_ATLANTIS_URL https://atlantis.ourcomain.com

# Set the GitHub user corresponding to the personal access token
chamber write atlantis ATLANTIS_GH_USER outcompanybot

# Set the GitHub personal access token corresponding to the github user
chamber write atlantis ATLANTIS_GH_TOKEN the-token-generated-by-github

# Set the WebHook callback secret
chamber write atlantis ATLANTIS_GH_WEBHOOK_SECRET 'super-secret-alphanumeric-key'

# Set the permitted repositories
chamber write atlantis ATLANTIS_REPO_WHITELIST 'github.com/cloudposse/*'
```

### Deploy Atlantis on ECS Fargate

This commands are asynchronous. You may need to retry them multiple times. 

```
make create/certificate
make validate/certificate
make create/lb
make create/service
```
