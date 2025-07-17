# frozen_string_literal: true

require "hanami"
require "securerandom"

RSpec.describe Hanami::RSpec::Commands::Generate::Action do
  describe "#call" do
    subject { described_class.new(fs: fs, inflector: inflector) }

    let(:fs) { Hanami::CLI::Files.new }
    let(:inflector) { Dry::Inflector.new }

    let(:app_name) { "Bookshelf" }

    let(:action_name) { "client.create" }

    context "app" do
      it "generates spec file" do
        within_application_directory do
          subject.call({name: action_name})

          action_spec = <<~EXPECTED
            # frozen_string_literal: true

            RSpec.describe #{app_name}::Actions::Client::Create do
              let(:params) { Hash[] }

              it "works" do
                response = subject.call(params)
                expect(response).to be_successful
              end
            end
          EXPECTED
          expect(fs.read("spec/actions/client/create_spec.rb")).to eq(action_spec)
        end
      end

      context "with nested controller name" do
        let(:action_name) { "reporting.annual.billing.index" }

        it "generates spec file" do
          within_application_directory do
            subject.call({name: action_name})

            # spec/<slice>/action_spec.rb
            action_spec = <<~EXPECTED
              # frozen_string_literal: true

              RSpec.describe #{app_name}::Actions::Reporting::Annual::Billing::Index do
                let(:params) { Hash[] }

                it "works" do
                  response = subject.call(params)
                  expect(response).to be_successful
                end
              end
            EXPECTED
            expect(fs.read("spec/actions/reporting/annual/billing/index_spec.rb")).to eq(action_spec)
          end
        end
      end

      context "skip_tests given" do
        it "does not generate a spec file" do
          within_application_directory do
            subject.call({name: action_name, skip_tests: true})

            expect(fs.exist?("spec/actions/client/create_spec.rb")).to be false
          end
        end
      end
    end

    context "slice" do
      let(:slice) { "main" }
      let(:slice_name) { "Main" }

      it "generates spec file" do
        within_application_directory do
          subject.call({slice: slice, name: action_name})

          action_spec = <<~EXPECTED
            # frozen_string_literal: true

            RSpec.describe #{slice_name}::Actions::Client::Create do
              let(:params) { Hash[] }

              it "works" do
                response = subject.call(params)
                expect(response).to be_successful
              end
            end
          EXPECTED
          expect(fs.read("spec/slices/#{slice}/actions/client/create_spec.rb")).to eq(action_spec)
        end
      end

      context "skip_tests given" do
        it "does not generate a spec file" do
          within_application_directory do
            subject.call({slice: slice, name: action_name, skip_tests: true})

            expect(fs.exist?("spec/slices/#{slice}/actions/client/create_spec.rb")).to be false
          end
        end
      end
    end
  end

  private

  def within_application_directory(app: app_name)
    dir = fs.join(TMP, SecureRandom.uuid, app)

    fs.mkdir(dir)
    fs.chdir(dir) do
      app_code = <<~CODE
        # frozen_string_literal: true

        require "hanami"

        module #{app}
          class App < Hanami::App
          end
        end
      CODE
      fs.write("config/app.rb", app_code)

      routes = <<~CODE
        # frozen_string_literal: true

        require "hanami/routes"

        module #{app}
          class Routes < Hanami::Routes
            define do
              root { "Hello from Hanami" }
            end
          end
        end
      CODE
      fs.write("config/routes.rb", routes)

      yield
    end
  end
end
