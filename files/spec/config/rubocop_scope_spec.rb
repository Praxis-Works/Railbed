# frozen_string_literal: true

require "rails_helper"
require "rubocop"

RSpec.describe "RuboCop scope" do
  subject(:cop_config) { config.fetch("Quality/PreferBarewordReaders") }

  let(:config) { RuboCop::ConfigLoader.load_file(Rails.root.join(".rubocop.yml")) }

  it "keeps bareword readers enforced" do
    expect(cop_config.fetch("Enabled")).to be(true)
  end

  it "allows Rails presentation layers to use framework-facing instance variables" do
    expect(cop_config.fetch("Exclude")).to contain_exactly(
      Rails.root.join("app/controllers/**/*").to_s,
      Rails.root.join("app/mailers/**/*").to_s,
      Rails.root.join("app/views/**/*").to_s
    )
  end
end
