---
name: contact-form-email-integration
description: Integrate one or more existing app contact forms with the central email microservice. Use when a user asks to connect forms to the contact-form-service endpoint, replace placeholder recipient/site values with page-specific data, configure contact form environment variables, preserve existing UI/styles, add frontend validation, submit/loading/error/success states, and report modified files plus where `to` and `site` were set.
---

# Contact Form Email Integration

## Workflow

1. Inspect the app stack before editing: package files, form components, route handlers, existing env conventions, and current styling patterns.
2. Find all relevant contact forms. Search for `form`, `contact`, `name`, `email`, `message`, `submit`, `mailto`, and existing submit handlers.
3. Preserve the existing UI and styles. Reuse current components, classes, CSS, and state patterns. Do not add dependencies unless the app truly lacks a built-in way to do the work.
4. Integrate each form with:

```text
POST https://contact-form-service-e8aa.onrender.com/api/contact
Content-Type: application/json
```

5. Trim `name`, `email`, and `message` before validating and sending.
6. Validate required `name`, `email`, and `message` on the frontend.
7. Validate email with a basic frontend pattern, for example `/^[^\s@]+@[^\s@]+\.[^\s@]+$/`.
8. Disable the submit button during submission.
9. Show loading, error, and success states without disrupting the existing layout.
10. Clear the form only when the response JSON includes `{ "success": true }`.
11. Verify with the repo's available checks when practical.

## Payload

Send this JSON body:

```json
{
  "name": "<trimmed name field>",
  "email": "<trimmed email field>",
  "to": "<env contact recipient>",
  "message": "<trimmed message field>",
  "site": "<env site identifier>",
  "company": ""
}
```

Never leave literal `REEMPLAZA` values in code. Derive the recipient and site identifier from the page/app context, then set them as environment variables.

## Environment Variables

Set `to` and `site` as env values using the framework's existing convention:

- Vite: `VITE_CONTACT_TO` and `VITE_CONTACT_SITE`
- Next.js client code: `NEXT_PUBLIC_CONTACT_TO` and `NEXT_PUBLIC_CONTACT_SITE`
- Create React App: `REACT_APP_CONTACT_TO` and `REACT_APP_CONTACT_SITE`
- Server-only code: `CONTACT_TO` and `CONTACT_SITE`

Read env values through the framework's standard API, such as `import.meta.env`, `process.env`, or the repo's existing config helper. If an `.env.example` or equivalent exists, update it too.

Choose values from the page's real data:

- `to`: the page owner's/contact recipient email found in the app, page content, existing `.env`, footer, contact copy, metadata, or project docs.
- `site`: the site/page identifier, usually the domain, brand name, app name, or page title visible in the project.

If the recipient cannot be discovered safely, do not invent it. Add the env key with an empty placeholder in example files and call out the missing value in the final answer.

## Implementation Notes

- Prefer editing the existing submit handler. If none exists, add one in the smallest relevant component/module.
- Keep validation messages and status text consistent with the app's language and tone.
- Keep styling changes minimal and scoped to existing selectors/components.
- Include defensive handling for non-2xx responses, invalid JSON, network errors, and `{ "success": false }`.
- Avoid logging submitted form data.
- Avoid backend changes unless the app already submits through its own API route or needs a server-only env variable to avoid exposing the recipient.

## Final Response

Return:

1. Modified files.
2. Where `to` and `site` were set, including exact env variable names and file paths.
3. Verification performed, or why checks were not run.
