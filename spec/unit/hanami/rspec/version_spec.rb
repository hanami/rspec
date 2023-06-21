# frozen_string_literal: true

RSpec.describe "Hanami::RSpec::VERSION" do
  it "returns version" do
    expect(Hanami::RSpec::VERSION).to eq("2.1.0.beta1")
  end
end
