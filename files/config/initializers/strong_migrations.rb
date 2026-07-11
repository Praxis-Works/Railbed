# frozen_string_literal: true

StrongMigrations.start_after = 0
StrongMigrations.lock_timeout = 10.seconds
StrongMigrations.statement_timeout = 1.hour
StrongMigrations.auto_analyze = true
