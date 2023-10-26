# frozen_string_literal: true

require "hanami"
require "securerandom"

RSpec.describe Hanami::RSpec::Commands::Generate::Part do
  describe "#call" do
    subject { described_class.new(fs: fs, inflector: inflector) }

    let(:fs) { Dry::Files.new }
    let(:inflector) { Dry::Inflector.new }

    let(:app_name) { "Bookshelf" }

    let(:part_name) { "client" }

    context "app" do
      context "without base part" do
        it "generates spec file" do
          within_application_directory do
            subject.call({name: part_name})

            if ruby_implicity_keyword_argument?
              base_part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{app_name}::Views::Part do
                  subject { described_class.new(value:) }
                  let(:value) { double("value") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/views/part_spec.rb")).to eq(base_part_spec)

              part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{app_name}::Views::Parts::Client do
                  subject { described_class.new(value:) }
                  let(:value) { double("client") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/views/parts/client_spec.rb")).to eq(part_spec)
            end

            unless ruby_implicity_keyword_argument?
              base_part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{app_name}::Views::Part do
                  subject { described_class.new(value: value) }
                  let(:value) { double("value") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/views/part_spec.rb")).to eq(base_part_spec)

              part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{app_name}::Views::Parts::Client do
                  subject { described_class.new(value: value) }
                  let(:value) { double("client") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/views/parts/client_spec.rb")).to eq(part_spec)
            end
          end
        end
      end

      context "with base part" do
        it "generates spec file" do
          within_application_directory do
            fs.touch("spec/views/part_spec.rb")

            subject.call({name: part_name})

            if ruby_implicity_keyword_argument?
              <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{app_name}::Views::Parts::Client do
                  subject { described_class.new(value:) }
                  let(:value) { double("client") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
            else
              part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{app_name}::Views::Parts::Client do
                  subject { described_class.new(value: value) }
                  let(:value) { double("client") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED

              expect(fs.read("spec/views/parts/client_spec.rb")).to eq(part_spec)
            end
          end
        end
      end
    end

    context "slice" do
      let(:slice) { "main" }
      let(:slice_name) { "Main" }

      context "without base part" do
        it "generates spec file" do
          within_application_directory do
            subject.call({slice: slice, name: part_name})

            if ruby_implicity_keyword_argument?
              base_part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{app_name}::Views::Part do
                  subject { described_class.new(value:) }
                  let(:value) { double("value") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/views/part_spec.rb")).to eq(base_part_spec)

              base_slice_part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{slice_name}::Views::Part do
                  subject { described_class.new(value:) }
                  let(:value) { double("value") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/slices/#{slice}/views/part_spec.rb")).to eq(base_slice_part_spec)

              part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{slice_name}::Views::Parts::Client do
                  subject { described_class.new(value:) }
                  let(:value) { double("client") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/slices/#{slice}/views/parts/client_spec.rb")).to eq(part_spec)
            end

            unless ruby_implicity_keyword_argument?
              base_part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{app_name}::Views::Part do
                  subject { described_class.new(value: value) }
                  let(:value) { double("value") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/views/part_spec.rb")).to eq(base_part_spec)

              base_slice_part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{slice_name}::Views::Part do
                  subject { described_class.new(value: value) }
                  let(:value) { double("value") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/slices/#{slice}/views/part_spec.rb")).to eq(base_slice_part_spec)

              part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{slice_name}::Views::Parts::Client do
                  subject { described_class.new(value: value) }
                  let(:value) { double("client") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
              expect(fs.read("spec/slices/#{slice}/views/parts/client_spec.rb")).to eq(part_spec)
            end
          end
        end
      end

      context "with base part" do
        it "generates spec file" do
          within_application_directory do
            fs.touch("spec/views/part_spec.rb")
            fs.touch("spec/slices/#{slice}/views/part_spec.rb")

            subject.call({slice: slice, name: part_name})

            if ruby_implicity_keyword_argument?
              part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{slice_name}::Views::Parts::Client do
                  subject { described_class.new(value:) }
                  let(:value) { double("client") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
            else
              part_spec = <<~EXPECTED
                # frozen_string_literal: true

                RSpec.describe #{slice_name}::Views::Parts::Client do
                  subject { described_class.new(value: value) }
                  let(:value) { double("client") }

                  it "works" do
                    expect(subject).to be_kind_of(described_class)
                  end
                end
              EXPECTED
            end
            expect(fs.read("spec/slices/#{slice}/views/parts/client_spec.rb")).to eq(part_spec)
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

  def ruby_implicity_keyword_argument?
    RUBY_VERSION >= "3.1"
  end
end
