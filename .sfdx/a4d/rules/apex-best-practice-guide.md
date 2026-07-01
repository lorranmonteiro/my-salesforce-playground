# Rule: Apex Best Practices
**Description:** Enforce naming and formatting standards for Apex code.
**Applies to:** `*/*.cls`

**Guidelines:**
- Class names must be PascalCase (e.g., `AccountService`, `OpportunityHelper`)
- Method names must be camelCase (e.g., `calculateTax`, `fetchOpportunities`)
- Variable names must be camelCase and descriptive (e.g., `accountList`, `isClosed`)
- Boolean variable names should start with `is`, `has`, or `can` (e.g., `isActive`, `hasAccess`)
- Use plural names for collections (e.g., `contacts`, `accountMap`)
- Avoid abbreviations and single-letter variables (e.g., `acc` X, `account` Avoid SOQL or DML inside `for` loops. Use Maps and Sets to bulkify logic
- When possible, perform DML using USER_MODE to respect sharing and field-level security. For example: `insert as user`, `update as user`
- Use `WITH USER_MODE` explicitly for SOQL queries
- Ensure the class uses `WITH SHARING` keyword to ensure the code runs in user mode by default
- Define constants (static final) in uppercase for values that do not change (e.g., status strings, record type IDs)
- Define and use custom exception classes instead of generic Exception or System.Exception
- Avoid empty try/catch blocks. Always log exceptions (System.debug(LoggingLevel.DEBUG, 'Error message here')) or rethrow them
- Use constructor-based dependency injection to facilitate unit testing and mocking.
- When exposing methods to Lightning Web Components, use (cacheable = true) for idempotent read operations
- Always enforce Field-Level Security (FLS) and CRUD in Apex where applicable, especially when running in system mode
- If possible, split the logic into smaller, reusable methods to improve readability and maintainability
- If possible, split new features into Domain, Service, and Selector layers to separate concerns and improve testability (using the Domain-Driven Design approach)
- If you are writing triggers, enforce using a standardized framework (TriggerHandler) to handle bulkification and avoid recursion. Push all logic to domain/service/helper classes. Triggers should only orchestrate
- Test classes must use PascalCase and end with `Test` (e.g., `AccountServiceTest`)
- Test method names should describe the test scenario clearly (e.g., `testCalculateTax_WithValidInput`)
- Ensure test methods cover bulk scenarios (e.g., handling multiple records at once), Postive and Negative scenarios, and edge cases
- Use `@IsTest` annotation for test classes and methods
- Use `@TestSetup` method to create common test data for all test methods in the class
- When writing Asserts always use System.Assert class instead of `System.assert`
- Ensure Code Coverage is Above 75%. But also focus on asserting behavior, not just increasing coverage
- Never use `SeeAllData=true` in Test Classes
