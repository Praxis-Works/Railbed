# frozen_string_literal: true

RSpec.describe "Sorbet strictness" do
  subject(:non_strict_files) { ruby_files.reject { |relative_path| strict?(relative_path) } }

  let(:project_root) { File.expand_path("../..", __dir__) }
  let(:ruby_files) { Dir.glob([ "app/**/*.rb", "lib/**/*.rb" ], base: project_root) }

  it "requires typed: strict for every Ruby file under app and lib" do
    expect(non_strict_files).to be_empty, failure_message
  end

  def strict?(relative_path)
    File.open(File.join(project_root, relative_path), &:readline).chomp == "# typed: strict"
  end

  def failure_message
    "Expected every app/lib Ruby file to start with # typed: strict; update: #{non_strict_files.join(', ')}"
  end
end
