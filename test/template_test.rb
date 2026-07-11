# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "pathname"
require "yaml"

class TemplateTest < Minitest::Test
  ROOT = Pathname.new(__dir__).join("..").expand_path

  def test_template_is_valid_ruby
    stdout, status = Open3.capture2e("ruby", "-c", ROOT.join("template.rb").to_s)
    assert status.success?, stdout
  end

  def test_all_cop_requires_resolve
    config = YAML.safe_load_file(ROOT.join("files/.rubocop.yml"), aliases: true)

    config.fetch("require").each do |required_path|
      relative_path = required_path.delete_prefix("./") + ".rb"
      assert ROOT.join("files", relative_path).file?, "Missing #{relative_path}"
    end
  end

  def test_template_assets_exist
    template = ROOT.join("template.rb").read
    copied_paths = template.scan(/copy_template_file \"([^\"]+)\"/).flatten

    copied_paths.each do |path|
      assert ROOT.join("files", path).file?, "Missing template asset: #{path}"
    end
  end

  def test_warespace_namespace_does_not_leak_into_generated_files
    generated_files = ROOT.join("files").glob("**/*").select(&:file?)
    leaks = generated_files.select { |path| path.read.include?("WareSpace") }

    assert_empty leaks, "WareSpace references remain in: #{leaks.join(', ')}"
  end

  def test_template_keeps_the_default_rails_schema_format
    template = ROOT.join("template.rb").read

    refute_includes template, "schema_format"
  end

  def test_every_gem_has_a_bounded_version
    gemfile = ROOT.join("files/Gemfile.tt").read
    unbounded = gemfile.lines.grep(/^\s*gem /).reject { |line| line.match?(/gem \"[^\"]+\", \"(?:~>|<|<=|=)/) }

    assert_empty unbounded, "Unbounded gems:\n#{unbounded.join}"
  end
end
