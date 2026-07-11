---
name: team-code-review
description: Review Rails application changes or pull requests by dispatching specialist agents, verifying every finding, and reporting only evidence-backed issues. Use when the user asks for a code review, PR review, review of a diff, or a multi-agent quality audit.
---

# Team Code Review for Rails

Run a read-only, evidence-driven review of this Rails application with specialist agents. The main agent owns scope, verification, deduplication, severity, and the final report.

## 1. Establish the review target

Determine whether the target is:

- **Own work:** changes produced by the current agent or agent team.
- **Another contributor's pull request:** a PR authored outside the current agent team.

Read `AGENTS.md` and other repository guidance first. Identify the exact review base and head, then inspect the complete diff and relevant surrounding code. Do not silently broaden the review to unrelated working-tree changes. If authorship is unclear, infer it from the conversation and PR metadata when available; ask only when the answer changes the workflow and cannot be discovered.

Record explicit non-goals and constraints. Keep the review read-only unless the user separately asks for fixes.

Before dispatching specialists, note which Rails surfaces changed: models, controllers, jobs, mailers, components/views, routes, migrations or `db/schema.rb`, configuration, dependencies, and operational documentation.

Completion criterion: the review target, authorship, base/head, repository guidance, changed files, and affected Rails surfaces are known.

## 2. Dispatch the review team

Use subagents when the runtime supports them. Give each specialist the same target, base/head, repository instructions, and read-only constraint. Assign non-overlapping primary lenses:

1. **Rails architecture and code quality** — assess responsibility placement across models, controllers, jobs, mailers, components, and plain Ruby collaborators. Check framework conventions, transaction boundaries, callbacks, dependency direction, duplication, and whether an abstraction solves a demonstrated problem. Prefer composition over inheritance: accept inheritance when the hierarchy represents a stable relationship and subclasses remain substitutable; otherwise favor small collaborators, delegation, and message passing. Apply Sandi Metz's POODR principles as a design lens: keep objects focused on one responsibility, depend on roles rather than concrete classes, isolate dependencies, minimize the knowledge objects have of one another, and contain the cost of change. Report a POODR concern only when the code demonstrates concrete coupling, duplication, a brittle change surface, or avoidable testing cost. Do not demand service objects, concerns, or other patterns by name without evidence that they improve the change.
2. **Ruby readability and types** — assess naming, control flow, error handling, Ruby/Rails idioms, and whether intent is easy to recover. Check `# typed: strict` compatibility, Sorbet signatures, nilability, and whether changed APIs require Tapioca DSL or shim updates. Treat formatter-only preferences as non-findings when RuboCop already owns them.
3. **RSpec and behavior coverage** — trace every changed behavior to meaningful RSpec coverage, including success, validation, authorization, failure, boundary, and regression paths. Prefer observable behavior over implementation-coupled expectations. Use the narrowest relevant spec first; consider request, job, mailer, ViewComponent, and system specs according to the boundary being changed. For external HTTP behavior, verify request construction, authentication, serialization, response parsing, status handling, timeouts, retries/idempotency, malformed responses, and WebMock coverage where applicable.
4. **Data, jobs, and performance** — inspect Active Record query shape, eager loading, N+1 exposure, locking, transaction behavior, cache consistency, and database constraints. Review migrations with Strong Migrations in mind, confirm `db/schema.rb` reflects intended schema changes, and flag unsafe boolean columns when a timestamp-backed state is appropriate. For Active Job and Solid Queue, check retry behavior, idempotency, serialization, queue choice, and whether work can observe uncommitted data.
5. **Rails security** — trace trust boundaries and data flow. Assess authentication, authorization, strong parameters, mass assignment, SQL injection, XSS and unsafe HTML, CSRF, redirects, file uploads, secret exposure, sensitive logging, dependency risk, tenant/account scoping, and secure failure behavior. Use Brakeman or focused reasoning as evidence, and do not inflate hypothetical risks beyond what the code supports.
6. **Documentation and operations** — check public interfaces, routes, configuration, environment variables, migrations, seed behavior, background operations, deployment steps, examples, and runbooks affected by the change. Confirm generated or application-specific Sorbet RBIs are updated when required and that setup or CI changes remain reproducible.

Ask every specialist to return only actionable findings with:

- severity and confidence;
- exact file and tight line range;
- the concrete failure mode or maintenance cost;
- evidence from the diff and relevant surrounding code;
- a concise remediation direction;
- tests or commands used to validate the claim.

Specialists should omit praise, style preferences without impact, speculative concerns, and findings outside the changed code unless the change directly activates them. They may inspect and run safe checks, but must not edit files or publish review comments.

Run specialists concurrently when capacity allows; batch them when it does not. The main agent must retain enough context and time to verify their work.

Completion criterion: every lens has been investigated and each specialist has either returned candidate findings or explicitly reported no actionable findings.

## 3. Verify every candidate finding

The main agent must independently verify every candidate before reporting it:

1. Open the cited lines and enough surrounding code to understand the Rails execution path.
2. Confirm the issue is introduced by or materially exposed by the target diff.
3. Search routes, callers, associations, callbacks, jobs, views/components, specs, configuration, schema definitions, generated-code boundaries, and documentation that could invalidate the claim.
4. Reproduce with the narrowest safe check available. Prefer a focused RSpec example or file, then the relevant static check. Run `bin/ci` when the review scope and environment make the full quality stack proportionate.
5. For database concerns, inspect both the migration and resulting `db/schema.rb`; do not infer a schema defect from one in isolation.
6. Calibrate severity to actual impact and likelihood.
7. Merge duplicates across specialists and discard unverified, speculative, or non-actionable items.

The generated app's full `bin/ci` includes dependency policy, RuboCop, Sorbet, RubyCritic, Bundler Audit, importmap audit, Brakeman, RSpec, and seed verification. Do not claim these checks passed unless they were actually run. If the environment prevents a check, report the gap instead of guessing.

Do not report a specialist's claim merely because it sounds plausible. The main agent is accountable for every final finding.

Completion criterion: every reported finding has independently checked evidence, an accurate location, a defensible severity, and a concrete impact; every rejected candidate is omitted.

## 4. Report the review

Lead with findings ordered by severity, then confidence. For each finding include:

- a short imperative title;
- severity;
- file and tight line range;
- why it matters in this specific Rails code path;
- the smallest useful remediation direction.

Then include:

- a concise overall assessment;
- testing performed and any checks that could not be run;
- remaining risks or coverage gaps;
- a brief note when no actionable findings were verified.

For **own work**, report the findings directly. Do not fix them unless the user asked for implementation.

For **another contributor's pull request**, provide the verified summary first, then ask whether the user wants a pull request review drafted on their behalf. Do not draft or publish the review before they agree.

If the user agrees to a PR review draft, invoke the `conventional-comments` skill and translate only the verified findings into Conventional Comments. Draft first; publish only with explicit authorization. Preserve severity, precise locations, and the distinction between blocking and non-blocking feedback.

## Review standard

- Review the change in repository and Rails runtime context, not as isolated snippets.
- Prefer concrete defects and material design costs over taste.
- Do not confuse missing tests with a proven production defect; describe the actual coverage risk.
- Treat framework magic as an execution path to trace, not a reason to assume correctness or failure.
- Prefer composition over inheritance and use POODR principles to evaluate responsibility, dependencies, collaboration, and change cost without treating them as dogma.
- Do not require a named pattern unless it resolves demonstrated duplication, coupling, inconsistency, or testability problems.
- A clean review is valid when all six lenses were investigated and no candidate survived verification.
