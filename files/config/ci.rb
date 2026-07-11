# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Dependencies: Policy", "bin/dependency-policy"
  step "Style: Ruby", "bin/rubocop"
  step "Types: Sorbet", "bundle exec srb tc"
  step "Quality: RubyCritic", "bin/rubycritic"
  step "Quality: Changed RubyCritic",
    'bin/rubycritic-changed "${RUBYCRITIC_BASE:-$(git hash-object -t tree /dev/null)}"'

  step "Security: Gem audit", "bin/bundler-audit"
  step "Security: Importmap vulnerability audit", "bin/importmap audit"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"
  step "Tests: RSpec", "bundle exec rspec"
  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"
end
