# frozen_string_literal: true

RSpec.describe Hanami::RSpec::Commands::Generate::Slice do
  describe "#call" do
    subject { described_class.new(fs: fs, inflector: inflector) }

    let(:fs) { Dry::Files.new(memory: true) }
    let(:inflector) { Dry::Inflector.new }
    let(:slice) { "main" }

    it "generates spec files, with hanami-view bundled" do
      allow(Hanami).to receive(:bundled?).with("hanami-view").and_return(true)

      subject.call({name: slice})

      # spec/<slice>/action_spec.rb
      action_spec = <<~EXPECTED
        # frozen_string_literal: true

        RSpec.describe #{inflector.camelize(slice)}::Action do
          xit "works"
        end
      EXPECTED
      expect(fs.read("spec/slices/#{slice}/action_spec.rb")).to eq(action_spec)

      # spec/<slice>/actions/.keep
      expect(fs.read("spec/slices/#{slice}/actions/.keep")).to eq("\n")

      # spec/<slice>/view_spec.rb
      view_spec = <<~EXPECTED
        # frozen_string_literal: true

        RSpec.describe #{inflector.camelize(slice)}::View do
        end
      EXPECTED
      expect(fs.read("spec/slices/#{slice}/view_spec.rb")).to eq(view_spec)
      expect(fs.read("spec/slices/#{slice}/views/.keep")).to eq("\n")

      # # spec/<slice>/repository_spec.rb
      # repository_spec = <<~EXPECTED
      #   # frozen_string_literal: true
      #
      #   require "slices/#{slice}/repository"
      #
      #   RSpec.describe #{inflector.camelize(slice)}::Repository do
      #   end
      # EXPECTED
      # expect(fs.read("spec/slices/#{slice}/repository_spec.rb")).to eq(repository_spec)

      # # spec/<slice>/entities/.keep
      # expect(fs.read("spec/slices/#{slice}/entities/.keep")).to eq(keep)
      #
      # # spec/<slice>/repositories/.keep
      # expect(fs.read("spec/slices/#{slice}/repositories/.keep")).to eq(keep)
    end

    it "generates spec files, without hanami-view bundled" do
      allow(Hanami).to receive(:bundled?).with("hanami-view").and_return(false)

      subject.call({name: slice})

      expect(fs.exist?("spec/slices/#{slice}/action_spec.rb"))
      expect(fs.exist?("spec/slices/#{slice}/actions/.keep"))

      expect(fs.exist?("spec/slices/#{slice}/view_spec.rb")).to be(false)
      expect(fs.exist?("spec/slices/#{slice}/views/.keep")).to be(false)
    end
  end
end
