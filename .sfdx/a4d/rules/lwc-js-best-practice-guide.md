# Rule: LWC Controller Structure
**Description:** Maintain consistent structure, security, and performance in LWC JS files.
**Applies to:** `**/*.js`

**Guidelines:**
- Import standard modules first (LightningElement, api, track, wire), then utilities, followed by custom components and services.
- Use decorators correctly: @api for public properties/methods, @track for mutable private reactive state, and @wire for service integrations.
- Do not mutate public (@api) properties directly; treat them as read-only within the component.
- Use leading underscores for private fields (e.g., _isLoading) to indicate internal use.
- Define static or hardcoded values as constants at the top of the file using UPPER_SNAKE_CASE, and freeze objects with Object.freeze() when immutability is required.
- Use immutable patterns when updating arrays or objects (e.g., this.items = [...this.items, newItem];) to maintain state integrity and avoid reactivity issues.
- Keep getters simple; move complex logic to private methods to improve readability and maintainability.
- Prefix all event handler methods with handle (e.g., handleClick, handleInputChange) and bind them in the controller instead of using inline handlers.
- Always define event.detail when dispatching custom events with this.dispatchEvent and dispatch user-friendly errors or status via CustomEvent for parent handling.
- Use try/catch blocks for all asynchronous operations and ensure all async functions return Promise objects to handle errors gracefully and avoid unhandled rejections.
- Prefer Promise.all() for running independent asynchronous tasks concurrently to improve performance.
- Use async/await syntax for asynchronous operations to improve readability and error handling
Avoid large or overly complex JavaScript files by splitting reusable logic into utility modules or service classes.
- Use let and const instead of var for variable declarations and prefer arrow functions for inline callbacks for consistency and scope safety.
- Use template literals (```) over string concatenation for clarity and readability.
- Use import { ShowToastEvent } from 'lightning/platformShowToastEvent'; for standardized user feedback rather than custom alerts.
- Use Custom Labels (import label from '@salesforce/label/...') for all user-facing strings to support localization and avoid hardcoding values.
- Avoid hardcoding Salesforce object and field API names; use schema imports or centralized constants for maintainability.
- Validate all inputs and parameters for @api methods and ensure proper input validation when handling user or external data.
- Use lifecycle hooks appropriately: `connectedCallback` for initialization logic. `renderedCallback` for post-render logic. `disconnectedCallback` to clean up resources like event listeners to prevent memory leaks.
- Minimize direct DOM manipulation; prefer using this.template.querySelector only when necessary and avoid manipulating LWC internals or breaking encapsulation.
- Avoid using global objects like window or document directly; respect Locker Service constraints to maintain security and compatibility.
- Never use `eval()` or `Function()` constructors to prevent security vulnerabilities and Locker Service violations.
- Avoid using JSON.parse() on untrusted data to prevent injection vulnerabilities; validate and sanitize external inputs.
- Avoid deep cloning unless necessary to prevent performance bottlenecks; use shallow copies when possible.
- Use this.template.querySelector or querySelectorAll sparingly, only for safe, encapsulated component interactions.
- Export only the main component class using export default class MyComponent extends LightningElement { ... }.
- Follow consistent naming conventions: PascalCase for classes, camelCase for methods/properties, and UPPER_SNAKE_CASE for constants.
- Avoid console logs (console.log) in production code; use console.warn or console.error only for critical debugging, and remove before deployment.
- Always ensure JavaScript files pass linting rules using eslint-plugin-lwc and follow Salesforce recommended configurations.
- Follow SLDS (Salesforce Lightning Design System) guidelines for styling and avoid inline styles to maintain UX consistency.
- Use dynamic imports `import()` for lazy-loading modules not always required, optimizing performance.