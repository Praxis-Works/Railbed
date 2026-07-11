# Rails Template

An opinionated Rails 8.1 application template extracted from the quality, testing, typing, and CI conventions developed in WareSpaceRails.

## What it installs

- PostgreSQL, Tailwind, importmap, Solid Queue/Cache/Cable, ViewComponent, `fx`, and timestamp-backed booleans
- RSpec, FactoryBot, Shoulda Matchers, SimpleCov, WebMock, Capybara, and Selenium
- Bullet N+1 enforcement and Strong Migrations
- Rails Omakase plus RSpec, FactoryBot, and ViewComponent RuboCop plugins
- Custom cops for inline classes, direct instance-variable reads, and boolean database columns
- RubyCritic with a 95/100 minimum score
- Sorbet strict mode and generated Tapioca gem/DSL RBIs
- Brakeman, Bundler Audit, bounded dependency policy, local `bin/ci`, and GitHub Actions

The template targets Ruby 4.0.5 and Rails 8.1.3. Generated applications use `structure.sql`.

## Usage

From this repository:

```bash
mise exec ruby@4.0.5 -- rails new my_app \
  --database=postgresql \
  --css=tailwind \
  --template="$(pwd)/template.rb"
```

From GitHub after this repository is published:

```bash
mise exec ruby@4.0.5 -- rails new my_app \
  --database=postgresql \
  --css=tailwind \
  --template=https://raw.githubusercontent.com/dgalarza/rails-template/main/template.rb
```

The template reads local assets when cloned and fetches them from the repository's raw `main` URL when invoked remotely. Override the remote asset location with `RAILS_TEMPLATE_ASSET_BASE_URL` when testing a fork or branch.

## Verify the template

Fast structural checks:

```bash
bin/test
```

End-to-end generation into a temporary directory:

```bash
INTEGRATION=1 bin/test
```

Inside a generated application, run:

```bash
bin/ci
```

Generated gem and DSL RBIs are application-specific and should be committed with the application.
