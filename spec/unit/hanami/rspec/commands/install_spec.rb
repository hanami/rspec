# frozen_string_literal: true

require "tmpdir"

RSpec.describe Hanami::RSpec::Commands::Install do
  describe "#call" do
    subject { described_class.new(fs: fs) }

    let(:fs) { Dry::Files.new }
    let(:dir) { Dir.mktmpdir }
    let(:app) { "synth" }
    let(:app_name) { "Synth" }

    let(:arbitrary_argument) { {} }

    around do |example|
      fs.chdir(dir) { example.run }
    ensure
      fs.delete_directory(dir)
    end

    it "copies a .rspec and spec helper" do
      subject.call(arbitrary_argument)

      # Gemfile
      gemfile = <<~EOF
        group :test do
          gem "capybara"
          gem "rack-test"
        end
      EOF
      expect(fs.read("Gemfile")).to include(gemfile)

      # .gitignore
      gitignore = <<~EOF
        spec/examples.txt
      EOF
      expect(fs.read(".gitignore")).to include(gitignore)

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

        ENV["HANAMI_ENV"] ||= "test"
        require "hanami/prepare"

        Dir["./spec/support/**/*.rb"].each { |f| require f }
      EOF
      expect(fs.read("spec/spec_helper.rb")).to eq(spec_helper)

      # spec/support/rspec.rb
      support_rspec = <<~EOF
        # frozen_string_literal: true

        RSpec.configure do |config|
          # Use the recommended non-monkey patched syntax.
          config.disable_monkey_patching!

          # Use and configure rspec-expectations.
          config.expect_with :rspec do |expectations|
            # This option will default to `true` in RSpec 4.
            expectations.include_chain_clauses_in_custom_matcher_descriptions = true
          end

          # Use and configure rspec-mocks.
          config.mock_with :rspec do |mocks|
            # Prevents you from mocking or stubbing a method that does not exist on a
            # real object.
            mocks.verify_partial_doubles = true
          end

          # This option will default to `:apply_to_host_groups` in RSpec 4.
          config.shared_context_metadata_behavior = :apply_to_host_groups

          # Limit a spec run to individual examples or groups you care about by tagging
          # them with `:focus` metadata. When nothing is tagged with `:focus`, all
          # examples get run.
          #
          # RSpec also provides aliases for `it`, `describe`, and `context` that include
          # `:focus` metadata: `fit`, `fdescribe` and `fcontext`, respectively.
          config.filter_run_when_matching :focus

          # Allow RSpec to persist some state between runs in order to support the
          # `--only-failures` and `--next-failure` CLI options. We recommend you
          # configure your source control system to ignore this file.
          config.example_status_persistence_file_path = "spec/examples.txt"

          # Uncomment this to enable warnings. This is recommended, but in some cases
          # may be too noisy due to issues in dependencies.
          # config.warnings = true

          # Show more verbose output when running an individual spec file.
          if config.files_to_run.one?
            config.default_formatter = "doc"
          end

          # Print the 10 slowest examples and example groups at the end of the spec run,
          # to help surface which specs are running particularly slow.
          config.profile_examples = 10

          # Run specs in random order to surface order dependencies. If you find an
          # order dependency and want to debug it, you can fix the order by providing
          # the seed, which is printed after each run:
          #
          # --seed 1234
          config.order = :random

          # Seed global randomization in this process using the `--seed` CLI option.
          # This allows you to use `--seed` to deterministically reproduce test failures
          # related to randomization by passing the same `--seed` value as the one that
          # triggered the failure.
          Kernel.srand config.seed
        end
      EOF
      expect(fs.read("spec/support/rspec.rb")).to eq(support_rspec)

      # spec/support/features.rb
      support_features = <<~EOF
        # frozen_string_literal: true

        require "capybara/rspec"

        Capybara.app = Hanami.app
      EOF
      expect(fs.read("spec/support/features.rb")).to eq(support_features)

      support_operations = <<~EOF
        # frozen_string_literal: true

        require "dry/monads"

        RSpec.configure do |config|
          # Provide `Success` and `Failure` for testing operation results
          config.include Dry::Monads[:result]
        end
      EOF
      expect(fs.read("spec/support/operations.rb")).to eq(support_operations)

      # spec/support/requests.rb
      support_requests = <<~EOF
        # frozen_string_literal: true

        require "rack/test"

        RSpec.shared_context "Rack::Test" do
          # Define the app for Rack::Test requests
          let(:app) { Hanami.app }
        end

        RSpec.configure do |config|
          config.include Rack::Test::Methods, type: :request
          config.include_context "Rack::Test", type: :request
        end
      EOF
      expect(fs.read("spec/support/requests.rb")).to eq(support_requests)

      # spec/requests/root_spec.rb
      request_spec = <<~EOF
        # frozen_string_literal: true

        RSpec.describe "Root", type: :request do
          it "is not found" do
            get "/"

            # Generate new action via:
            #   `bundle exec hanami generate action home.index --url=/`
            expect(last_response.status).to be(404)
          end
        end
      EOF
      expect(fs.read("spec/requests/root_spec.rb")).to eq(request_spec)
    end
  end
end
