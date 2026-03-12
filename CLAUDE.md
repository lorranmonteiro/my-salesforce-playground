# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Salesforce CLI (sf)
```bash
# Deploy all metadata to org
sf project deploy start --source-dir force-app

# Deploy a single file
sf project deploy start --source-file force-app/main/accounts/classes/AccountService.cls

# Run all Apex tests
sf apex run test --synchronous

# Run a single Apex test class
sf apex run test --class-names AccountServiceTest --synchronous

# Run tests with code coverage
sf apex run test --code-coverage --synchronous

# Open org in browser
sf org open
```

### JavaScript / LWC
```bash
# Install dependencies
npm install

# Lint LWC/Aura JS files
npm run lint

# Run LWC Jest unit tests
npm test

# Run a single LWC test file (use Jest's --testPathPattern)
npx sfdx-lwc-jest -- --testPathPattern=searchCmp

# Run LWC tests in watch mode
npm run test:unit:watch

# Run LWC tests with coverage
npm run test:unit:coverage

# Format all files with Prettier
npm run prettier

# Verify formatting without writing
npm run prettier:verify
```

## Architecture

### Directory Structure
- `force-app/main/` — Feature modules, each self-contained with `classes/`, `tests/`, `lwc/`, `triggers/`, `api/`
  - `accounts/` — Account domain: triggers, service, selector, batch, queueable, REST API
  - `integrations/gitlab/` — GitLab API integration
  - `integrations/openAI/` — OpenAI API integration
  - `serviceCloud/` — Experience sites (portal, help center), Knowledge articles
  - `default/` — Shared LWC components and static resources
- `force-app/utils/` — Reusable frameworks and utilities
  - `frameworks/triggerHandler/` — Base `TriggerHandler` class
  - `frameworks/logging/` — `LogCollector` / `LogService` / `LogQueueable`
  - `frameworks/featureFlags/` — `FeatureFlags` backed by `FeatureFlag__mdt`
  - `frameworks/metadataService/` — Metadata API wrappers
  - `frameworks/prepareSandbox/` — Sandbox setup utilities
  - `shared/` — `Constants`, `StringUtils`, `APIErrorResponse`

### Trigger Handler Framework
All triggers are a single line: `new XxxTriggerHandler().run()`. Handlers extend `TriggerHandler` (in `utils/frameworks/triggerHandler/`) and override context-specific virtual methods (`afterInsert`, `afterUpdate`, etc.). `TriggerHandler.run()` calls `LogCollector.flush()` at the end of every execution.

To bypass a handler in tests: `TriggerHandler.bypass('AccountTriggerHandler')` / `TriggerHandler.bypassAllTriggers = true`.

### Selector Pattern
All SOQL lives in dedicated `*Selector` classes (e.g., `AccountSelector`). Queries use `WITH SECURITY_ENFORCED`. Services and APIs never contain inline SOQL.

### Service Factory Pattern (for integrations)
External service classes (e.g., `GitlabService`, `OpenAIService`) are accessed through a `*ServiceFactory` implementing `IServiceFactory`. In tests, factories auto-return a mock success class if no mock is explicitly set; use `XxxServiceFactory.setMock(new MyMock())` to inject a specific mock.

### Logging Framework
- `LogService` — Static methods to build `Log__c` records for callouts, API requests, and exceptions.
- `LogCollector` — Accumulates `Log__c` records within a transaction.
- `LogQueueable` — Persists collected logs asynchronously via `System.enqueueJob`.
- Pattern: call `LogService.logXxx(...)` throughout business logic, then call `LogCollector.flush()` at transaction boundaries (done automatically by `TriggerHandler.run()` and explicitly in REST API methods).

### REST API Layer
REST endpoints live in `force-app/main/<domain>/api/`. Each `@RestResource` class delegates validation to a companion `*APIHelper` class (guards: CRUD permission check, ID/body validation, existence check) and uses `AccountSelector` for data access. Errors are serialized as `APIErrorResponse { message }`.

### Feature Flags
`FeatureFlags` evaluates flags in priority order: (1) mock value (tests only), (2) Custom Permission, (3) `FeatureFlag__mdt` record. Use `FeatureFlags.setMockValue(name, value)` in tests. LWC can call `FeatureFlags.lwcEvaluate(name)` via `@AuraEnabled`.

### Integration Configuration
Integration endpoints and settings are stored in Custom Metadata Types: `IntegrationEndpoint__mdt` (method, URL template, content type) and `IntegrationSetting__mdt` (IDs and credentials). Named Credentials (e.g., `callout:GitlabAPI`) handle authentication.

### Code Analysis
`code-analyzer.yml` configures Salesforce Code Analyzer rules for Apex, JavaScript, and Visualforce. ESLint is configured via `eslint.config.mjs` using `@salesforce/eslint-config-lwc`.

### Salesforce API Version
`sourceApiVersion: 66.0` (set in `sfdx-project.json`).
