# frozen_string_literal: true

require "rubocop"
require_relative "../../../../lib/rubocop/cop/quality/no_inline_class"

RSpec.describe RuboCop::Cop::Quality::NoInlineClass do
  subject(:offenses) { investigate(source) }

  let(:config) { RuboCop::Config.new("Quality/NoInlineClass" => { "Enabled" => true }) }
  let(:cop) { described_class.new(config) }

  context "when a class is nested in a class with behavior" do
    let(:source) do
      <<~RUBY
        class Account
          def active?
            true
          end

          class Membership
          end
        end
      RUBY
    end

    it "reports the nested class" do
      expect(offenses.map(&:message)).to contain_exactly(
        "Inline class/module definitions are forbidden. Extract 'Membership' to its own file."
      )
    end
  end

  context "when modules form a pure namespace wrapper chain" do
    let(:source) do
      <<~RUBY
        module Example
          module Accounts
            class Membership
            end
          end
        end
      RUBY
    end

    it "allows the wrapper chain" do
      expect(offenses).to be_empty
    end
  end

  def investigate(source)
    processed_source = RuboCop::ProcessedSource.new(source, RuboCop::TargetRuby::DEFAULT_VERSION)
    RuboCop::Cop::Team.new([ cop ], config, raise_error: true).investigate(processed_source).offenses
  end
end
