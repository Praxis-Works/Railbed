# frozen_string_literal: true

require "rails_helper"
require "net/http"

RSpec.describe "testing stack" do
  it "uses RSpec for generated tests" do
    expect(Rails.application.config.generators.options[:rails][:test_framework]).to eq(:rspec)
  end

  it "makes FactoryBot syntax available" do
    expect(self).to respond_to(:build)
  end

  it "checks every migration created in this repository" do
    expect(StrongMigrations.start_after).to eq(0)
  end

  it "enables Bullet during specs" do
    expect(Bullet.enable?).to be(true)
  end

  it "turns Bullet findings into spec failures" do
    expect(UniformNotifier.active_notifiers).to include(UniformNotifier::Raise)
  end

  it "profiles queries in every example" do
    expect(Bullet.start?).to be(true)
  end

  it "blocks unstubbed external HTTP requests" do
    expect { Net::HTTP.get(URI("https://example.com")) }
      .to raise_error(WebMock::NetConnectNotAllowedError)
  end
end
