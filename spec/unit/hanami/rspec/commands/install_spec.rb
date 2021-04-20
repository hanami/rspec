# frozen_string_literal: true

RSpec.describe Hanami::RSpec::Commands::Install do
  describe "#call" do
    subject { described_class.new(fs: fs) }

    let(:fs) { instance_double(Dry::Files) }

    let(:helper_directory) do
      File.expand_path(
        File.join(__dir__, "..", "..", "..", "..", "..", "lib", "hanami", "rspec")
      )
    end
    let(:helper_file) { "helper.rb" }

    let(:source_path) { File.join(helper_directory, helper_file) }
    let(:destination_path) { File.join("spec", "spec_helper.rb") }
    let(:destination_absolute_path) { File.join(Dir.pwd, destination_path) }

    it "creates a spec helper" do
      expect(fs).to receive(:cp)
        .with(source_path, destination_absolute_path)

      expect(fs).to receive(:expand_path)
        .with(helper_file, helper_directory)
        .and_return(source_path)

      expect(fs).to receive(:join)
        .with("spec", "spec_helper.rb")
        .and_return(destination_path)

      expect(fs).to receive(:expand_path)
        .with("spec/spec_helper.rb")
        .and_return(destination_absolute_path)

      subject.call
    end
  end
end
