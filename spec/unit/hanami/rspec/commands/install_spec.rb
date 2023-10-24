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
          gem "rack-test"
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

        ENV["HANAMI_ENV"] ||= "test"
        require "hanami/prepare"

        require_relative "support/rspec"
        require_relative "support/requests"
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

      # spec/support/requests.rb
      support_requests = <<~EOF
        # frozen_string_literal: true

        require "rack/test"

        RSpec.shared_context "Hanami app" do
          let(:app) { Hanami.app }
        end

        RSpec.configure do |config|
          config.include Rack::Test::Methods, type: :request
          config.include_context "Hanami app", type: :request
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
