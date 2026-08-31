# Salesforce Playground

A personal Salesforce development org showcasing enterprise-grade architecture, design patterns, and CI/CD practices.
This project follows a domain-driven, layered architecture with clear separation of concerns:

- **Selector pattern** — Most `SOQL` are centralized in `Selector` classes (`AccountSelector`, `UserSelector`) using `WITH USER_MODE`, enforcing sharing and field-level security at query time.
- **Service layer** — business logic lives in Service classes (e.g., `AccountService`) with no inline SOQL.
- **Trigger Handler framework** — triggers are one-liners (`new AccountTriggerHandler().run()`) delegating to a reusable `TriggerHandler` base class with context dispatch, recursion (loop-count) control, and a bypass mechanism (`bypass`/`bypassAllTriggers`).
- **Service Factory** — integrations (GitLab, OpenAI, Gemini) are resolved through factories that auto-return mocks in tests and support `setMock()` injection.
- **REST API layer** — `@RestResource` endpoints delegate validation to `APIHelper` guards (CRUD permission checks, ID/body validation, existence) and serialize errors as `APIErrorResponse`.

It follows Salesforce best practices for Apex, LWC, and REST APIs, with a focus on maintainability, testability, and security. Inspired by the [Apex Well-Architected Framework](https://www.awaf.dev).

## Design patterns

| Pattern | Implementation |
|---|---|
| Singleton | `Constants.getInstance()` (lazy, private constructor) |
| Factory | `GitlabServiceFactory`, `OpenAiServiceFactory`, `GeminiServiceFactory` via `IServiceFactory` |
| Strategy | `AIServiceFactory.getService()` selects OpenAI or Gemini at runtime from `IntegrationSetting__mdt` |
| Adapter | `IAIService` normalizes `OpenAIService` and `GeminiService` behind a single `getResponse(String)` contract |

## Salesforce ecosystem implementations

- **Integrations** — GitLab, OpenAI and Gemini secured through Named Credentials (`callout:*`) with typed request/response models, configuration in `IntegrationSetting__mdt`, and mock-based test coverage.
- **Feature Flags** — `FeatureFlags` backed by Custom Metadata (`FeatureFlag__mdt`) and Custom Permissions, exposed to LWC via `@AuraEnabled lwcEvaluate()`.
- **Fire-and-forget logging** — `LogService` publishes a `LogEvent__e` Platform Event via `EventBus.publish`, a non-blocking, asynchronous call that decouples logging from the caller's transaction and governor limits; a Flow (`CreateLogFromLogPlatformEvent`) persists the events into `Log__c`. It captures callouts (request/response), REST API traffic, and exceptions (type, message, stack trace, class/method), truncating payloads with `StringUtils`.
- **Async processing** — Queueable + Finalizer (`AccountNamePostNoteQueueable`, chunking callouts per transaction), Batch + Stateful (`AccountTypeUpdateBatch`) with a Scheduler, and Change Data Capture (`AccountChangeEvent` trigger).
- **Platform Events + EMP API** — `Notification__e` streamed in real time to the `notificationConsole` LWC.
- **Platform Cache** — `Cache.Org` used to cache GitLab responses (`GitLabProjectInfo`).
- **Metadata API + SandboxPostCopy** — `MetadataService` SOAP wrapper and `PrepareMySandbox` updating Named Credentials after sandbox refresh.
- **LWC** — Lightning Data Service wire adapters (`getRecord`, `getObjectInfo`, `getPicklistValues`, `getRelatedListRecords`), Lightning Message Service (`GitlabProjectAccountDetails__c` channel), EMP API, Navigation, and markdown-it static resource rendering.
- **React App** — Custom UI used on a Salesforce App

## DevOps & Code Quality

The repository includes full GitHub and GitLab CI/CD pipelines with static code analysis (Salesforce Code Analyzer + custom PMD rules), LWC Jest tests, scratch org validation deploys, and delta-based deployments using [sfdx-git-delta](https://github.com/scolladon/sfdx-git-delta). Code quality is enforced through PMD, ESLint, and Prettier. Tests use the modern `Assert` class, `@TestSetup`, and mock-based factories for full coverage of exception scenarios.

Built as a living portfolio of senior-level Salesforce engineering — from clean Apex architecture and Lightning Web Components to automated testing and continuous delivery.
