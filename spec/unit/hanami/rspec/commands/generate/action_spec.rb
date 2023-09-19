# frozen_string_literal: true

require "hanami"
require "securerandom"

RSpec.describe Hanami::RSpec::Commands::Generate::Action do
  describe "#call" do
    subject { described_class.new(fs: fs, inflector: inflector) }

    let(:fs) { Dry::Files.new }
    let(:inflector) { Dry::Inflector.new }

    let(:app_name) { "Bookshelf" }

    let(:action_name) { "client.create" }

    let(:bundled_views) { true }

    before do
      # TODO: this is a hack to get the tests to pass. We need to figure out how to stub this properly.
      allow_any_instance_of(Hanami::CLI::Generators::App::ActionContext).to receive(:bundled_views?)
        .and_return(bundled_views)
    end

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

          view_spec = <<~EXPECTED
            # frozen_string_literal: true

            RSpec.describe #{app_name}::Views::Client::Create do
              it "works" do
                rendered = subject.call
                expect(rendered).to match("#{app_name}::Views::Client::Create")
              end
            end
          EXPECTED
          expect(fs.read("spec/views/client/create_spec.rb")).to eq(view_spec)
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

      context "without bundled views" do
        let(:bundled_views) { false }

        it "skips views file" do
          within_application_directory do
            subject.call({name: action_name})

            expect(fs.exist?("spec/actions/client/create_spec.rb")).to be(true)
            expect(fs.exist?("spec/views/client/create_spec.rb")).to be(false)
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

          view_spec = <<~EXPECTED
            # frozen_string_literal: true

            RSpec.describe #{slice_name}::Views::Client::Create do
              it "works" do
                rendered = subject.call
                expect(rendered).to match("#{slice_name}::Views::Client::Create")
              end
            end
          EXPECTED
          expect(fs.read("spec/slices/#{slice}/views/client/create_spec.rb")).to eq(view_spec)
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
