# Rails Template Contributor Guide

This repository builds generated Rails applications from `template.rb` and the assets under `files/`. Changes to generated behavior must update the source asset, the template copy list, and the template tests together.

## Workflow

Use tests to define behavior before implementing it. Run `bin/test` for the fast template contract suite and `INTEGRATION=1 bin/test` when generated application behavior changes.

## Definition of Done

A change is complete when:

- `bin/test` passes, and generation-affecting changes pass `INTEGRATION=1 bin/test`.
- Generated applications retain the aggregate `bin/rubycritic` minimum score of 95/100.
- `bin/rubycritic-changed <base-ref>` reports no blocking complexity in changed Ruby files under `app/` or `lib/`.
- Generated RuboCop, Sorbet, dependency-policy, test, and security checks remain passing.
- Contributor guidance, generated documentation, and CI agree with the shipped behavior.

Short explicit mappings may remain visible in RubyCritic's focused report. Do not replace clear code with metaprogramming solely to silence an advisory metric.
