# frozen_string_literal: true

require "rubocop"
require_relative "../../../../lib/rubocop/cop/quality/prefer_bareword_readers"

RSpec.describe RuboCop::Cop::Quality::PreferBarewordReaders do
  subject(:offenses) { investigate(source) }

  let(:config) { RuboCop::Config.new("Quality/PreferBarewordReaders" => { "Enabled" => true }) }
  let(:cop) { described_class.new(config) }

  context "with a direct instance variable read" do
    let(:source) do
      <<~RUBY
        class Example
          attr_reader :value

          def call
            @value.to_s
          end
        end
      RUBY
    end

    it "reports the read" do
      expect(offenses.map(&:message)).to contain_exactly(
        "Use the `value` reader instead of reading `@value` directly."
      )
    end
  end

  context "when inside the reader" do
    let(:source) do
      <<~RUBY
        class Example
          def value
            @value
          end
        end
      RUBY
    end

    it "allows access to the backing instance variable" do
      expect(offenses).to be_empty
    end
  end

  context "with an assignment" do
    let(:source) do
      <<~RUBY
        class Example
          def initialize(value)
            @value = value
          end
        end
      RUBY
    end

    it "allows the assignment" do
      expect(offenses).to be_empty
    end
  end

  def investigate(source)
    processed_source = RuboCop::ProcessedSource.new(source, RuboCop::TargetRuby::DEFAULT_VERSION)
    RuboCop::Cop::Team.new([ cop ], config, raise_error: true).investigate(processed_source).offenses
  end
end
