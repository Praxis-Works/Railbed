# Rails Application Contributor Guide

## Quality Commands

```bash
bin/dependency-policy
bundle exec rspec
bin/rubocop
bundle exec srb tc
bin/rubycritic
bin/rubycritic-changed <base-ref>
bin/brakeman --no-pager
bin/bundler-audit
bin/importmap audit
env RAILS_ENV=test bin/rails db:seed:replant
```

## Definition of Done

A change is complete when:

- Focused specs and the full relevant RSpec suite pass.
- RuboCop, Sorbet, and relevant security checks pass.
- `bin/rubycritic` preserves the aggregate 95/100 maintainability floor.
- `bin/rubycritic-changed <base-ref>` reports no blocking complexity in changed Ruby files under `app/` or `lib/`.
- New behavior has meaningful success, failure, and boundary coverage.

Short explicit mappings may remain visible in RubyCritic's focused report. Do not introduce metaprogramming solely to silence an advisory metric.
