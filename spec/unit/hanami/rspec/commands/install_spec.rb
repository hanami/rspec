# frozen_string_literal: true

require "hanami/rspec/commands"
require "tmpdir"

RSpec.describe Hanami::RSpec::Commands::Install do
  describe "#call" do
    subject { described_class.new(fs: fs) }

    let(:fs) { Dry::Files.new }
    let(:dir) { Dir.mktmpdir }
    let(:app) { "synth" }
    let(:app_name) { "Synth" }

    around do |example|
      fs.chdir(dir) { example.run }
    ensure
      fs.delete_directory(dir)
    end

    it "copies a .rspec and spec helper" do
      subject.call(app: app)

      # Gemfile
      gemfile = <<~EOF
        group :test do
          gem "capybara"
        end
      EOF
      expect(fs.read("Gemfile")).to include(gemfile)

      # .rspec
      dotrspec = <<~EOF
        --require spec_helper
      EOF
      expect(fs.read(".rspec")).to eq(dotrspec)

      # spec/spec_helper.rb
      spec_helper = <<~EOF
        # frozen_string_literal: true

        require "pathname"
        SPEC_ROOT = Pathname(__dir__).realpath.freeze

        require "hanami/prepare"

        require_relative "support/rspec"
        require_relative "support/features"
      EOF
      expect(fs.read("spec/spec_helper.rb")).to eq(spec_helper)

      # spec/support/rspec.rb
      support_rspec = <<~EOF
        # frozen_string_literal: true

        RSpec.configure do |config|
          config.expect_with :rspec do |expectations|
            expectations.include_chain_clauses_in_custom_matcher_descriptions = true
          end

          config.mock_with :rspec do |mocks|
            mocks.verify_partial_doubles = true
          end

          config.shared_context_metadata_behavior = :apply_to_host_groups

          config.filter_run_when_matching :focus

          config.disable_monkey_patching!
          config.warnings = true

          if config.files_to_run.one?
            config.default_formatter = "doc"
          end

          config.profile_examples = 10

          config.order = :random
          Kernel.srand config.seed
        end
      EOF
      expect(fs.read("spec/support/rspec.rb")).to eq(support_rspec)

      # spec/support/features.rb
      support_features = <<~EOF
        # frozen_string_literal: true

        require "capybara/rspec"

        Capybara.app = Hanami.app
        Capybara.server = :puma, {Silent: true}
      EOF
      expect(fs.read("spec/support/features.rb")).to eq(support_features)

      # spec/features/home_spec.rb
      support_features = <<~EOF
        # frozen_string_literal: true

        RSpec.feature "Visit the home page" do
          scenario "It shows the page title" do
            visit "/"

            expect(page).to have_title "\#{app_name}"
          end
        end
      EOF
      expect(fs.read("spec/features/home_spec.rb")).to eq(support_features)
    end
  end
end
