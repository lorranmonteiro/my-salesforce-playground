FROM salesforce/cli:latest-slim

ENV SF_USE_GENERIC_UNIX_KEYCHAIN=true
ENV SF_IMPROVED_CODE_COVERAGE=true
ENV SF_HIDE_RELEASE_NOTES=true
ENV SF_LOG_LEVEL=warn
ENV SF_DISABLE_TELEMETRY=true
ENV SF_CONTAINER_MODE=true
ENV SF_DISABLE_AUTOUPDATE=true

RUN sf plugins install code-analyzer@latest
RUN echo 'y' | sf plugins install sfdx-git-delta@latest
