# Rule: LWC Template Structure
**Description:** Maintain consistent structure in LWC HTML files.
**Applies to:** `**/*.html`

**Guidelines:**
- Group conditional rendering (`lwc:if`/`lwc: elseif`) elements together
- Include a comment block before each major section
- Avoid using `if:true` and `if:false` for conditional logic in templates. Instead Use `lwc:if`, `lwc:elseif`, and `lwc:else` directives for forward compatibility
- Alwayes use key Directive in Iteration Blocks
- Always Use Semantic HTML Elements to improve accessibility (a11y)
- Ensure ARIA Attributes and Accessibility Standards, to comply with WCAG and Salesforce's accessibility policies
- Minimize use of inline style Attributes to maintain separation of concerns. Styles should go in `.css` files
- Use Salesforce Lightning Design System (SLDS) classes for styling and layout. Use Lightning base components where possible
- Prefer lightning-layout and lightning-layout-item for Grid Structures
- When possible, use slot Elements for Reusable Components
- Avoid Deep Nesting of Elements. If nesting exceeds 6 levels, consider refactoring into sub-components
- Prefer template Tags for Conditional and Iterative Blocks
- Use lwc:if to remove elements from the DOM instead of toggling display:none
- Always Close All HTML Tags Explicitly
- Keep templates purely for view rendering. Business logic must stay in the JS controller
- If possible, use Custom Labels for translatable strings to support localization
- Consistently Use Lowercase for HTML Tag Names