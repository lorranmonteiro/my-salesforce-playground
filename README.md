# Salesforce Playground

A personal Salesforce development org showcasing enterprise-grade architecture, design patterns, and CI/CD practices.

This project follows a domain-driven, layered architecture with clear separation of concerns: all `SOQL` is centralized in Selector classes with `WITH USER_MODE`, business logic lives in Service classes behind mockable interfaces (Service Factory pattern), and triggers are thin entry points that delegate to a reusable Trigger Handler framework. External integrations with GitLab and OpenAI are secured through Named Credentials and External Credentials, with typed request/response models and comprehensive mock-based test coverage. It follows Salesforce best practices for Apex, LWC, and REST APIs, with a focus on maintainability, testability, and security. It's inspired by the [Apex Well-Architected Framework](https://www.awaf.dev).

On the DevOps side, the repository includes a full Github and GitLab CI/CD pipelines with static code analysis (Salesforce Code Analyzer + custom PMD rules), LWC Jest tests, scratch org validation deploys, and delta-based deployments using [sfdx-git-delta](https://github.com/scolladon/sfdx-git-delta). Code quality is enforced through PMD, ESLint, and Prettier. A custom Logging Framework captures callouts, exceptions, and DML operations asynchronously, while Feature Flags backed by Custom Metadata enable safe, togglable feature rollout.

Built as a living portfolio of senior-level Salesforce engineering — from clean Apex architecture and Lightning Web Components to automated testing and continuous delivery.
