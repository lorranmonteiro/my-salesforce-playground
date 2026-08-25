# Salesforce Development Guidelines for Agents

## Apex Best Practices
- Bulkification: Never perform SOQL queries or DML statements inside loops (`for`, `while`). Always use collections (Lists, Sets, Maps).
- Triggers: There should be only one Trigger per sObject. All business logic must be delegated to Handler/Service classes (Trigger Handler Pattern).
- No Hardcoding: Never use record IDs directly in the code (hardcoded). Use Custom Metadata Types, Custom Settings, or dynamic queries.
- Braces: If a code block inside an `if`, `else`, or `for` statements consists of only a single short line, braces `{}` are not required. Always prioritize code readability by maintaining proper spacing.

## Apex Unit Testing
- Assertions: Use modern methods from the `Assert` class (e.g., `Assert.areEqual()`, `Assert.isTrue()`) instead of `System.assertEquals()`.
- Limits: Use `Test.startTest()` and `Test.stopTest()` to reset governor limits for the execution of the primary code. Code between `startTest()` and `stopTest()` must be indented by one tab.
- Test Coverage: Always aim for close to 100% coverage and ensure all exception scenarios are tested. Never use org data. Aim to use `@TestSetup` to create test data and `@IsTest` for test methods.

## Lightning Web Components (LWC)
- Security and LDS: Always prioritize the Lightning Data Service (such as `lightning-record-form` or wire adapters from `lightning/uiRecordApi`) before resorting to imperative Apex methods.
- Styling: Use SLDS utility classes as much as possible. Avoid inline CSS or global CSS selectors that break Shadow DOM encapsulation. Use SLDS Global Styling Hooks for style customizations.
- Accessibility: Ensure all inputs have corresponding associated `<label>` elements and use aria-* attributes where necessary.
- Jest Tests: When creating complex LWC components, require Cline to also generate the corresponding Jest tests in the `__tests__` folder.

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
  - `frameworks/logging/` — `LogService` (publishes `LogEvent__e` Platform Event) + `Log__c` custom object
  - `frameworks/featureFlags/` — `FeatureFlags` backed by `FeatureFlag__mdt`
  - `frameworks/metadataService/` — Metadata API wrappers
  - `frameworks/prepareSandbox/` — Sandbox setup utilities
  - `shared/` — `Constants`, `StringUtils`, `APIErrorResponse`

### Trigger Handler Framework
All triggers are a single line: `new XxxTriggerHandler().run()`. Handlers extend `TriggerHandler` (in `utils/frameworks/triggerHandler/`) and override context-specific virtual methods (`afterInsert`, `afterUpdate`, etc.).

To bypass a handler in tests: `TriggerHandler.bypass('AccountTriggerHandler')` / `TriggerHandler.bypassAllTriggers = true`.

### Selector Pattern
All SOQL lives in dedicated `*Selector` classes (e.g., `AccountSelector`). Queries use `WITH USER_MODE`. Services and APIs never contain inline SOQL.

### Service Factory Pattern (for integrations)
External service classes (e.g., `GitlabService`, `OpenAIService`) are accessed through a `*ServiceFactory` implementing `IServiceFactory`. In tests, factories auto-return a mock success class if no mock is explicitly set; use `XxxServiceFactory.setMock(new MyMock())` to inject a specific mock.

### Logging Framework
- ToDo

### REST API Layer
REST endpoints live in `force-app/main/<domain>/api/`. Each `@RestResource` class delegates validation to a companion `*APIHelper` class (guards: CRUD permission check, ID/body validation, existence check) and uses `AccountSelector` for data access. Errors are serialized as `APIErrorResponse { message }`.

### Feature Flags
`FeatureFlags` evaluates flags in priority order: (1) mock value (tests only), (2) Custom Permission, (3) `FeatureFlag__mdt` record. Use `FeatureFlags.setMockValue(name, value)` in tests. LWC can call `FeatureFlags.lwcEvaluate(name)` via `@AuraEnabled`.

### Integration Configuration
Integration endpoints and settings are stored in Custom Metadata Types: `IntegrationEndpoint__mdt` (method, URL template, content type) and `IntegrationSetting__mdt` (IDs and credentials). Named Credentials (e.g., `callout:GitlabAPI`) handle authentication.

### Code Analysis
`code-analyzer.yml` configures Salesforce Code Analyzer rules for Apex, JavaScript, and Visualforce. ESLint is configured via `eslint.config.mjs` using `@salesforce/eslint-config-lwc`.

### Salesforce API Version
Always use the API version specified in `sfdx-project.json`, on the `sourceApiVersion` attribute, for new development and deployments.
