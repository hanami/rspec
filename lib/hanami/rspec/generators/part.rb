# frozen_string_literal: true

require "hanami/cli/generators/app/ruby_class_file"

module Hanami
  module RSpec
    module Generators
      # @since 2.1.0
      # @api private
      class Part
        # @since 2.1.0
        # @api private
        def initialize(fs:, inflector:)
          @fs = fs
          @inflector = inflector
        end

        # @since 2.1.0
        # @api private
        def call(key:, namespace:, base_path:, app_namespace:)
          ruby_class_file = part_ruby_class_file(key:, namespace:, base_path:)
          spec_file_path = ruby_class_file.path.gsub(/\.rb$/, "_spec.rb")
          part_class_name = ruby_class_file.fully_qualified_name

          generate_base_part_specs(namespace:, base_path:, app_namespace:)
          fs.write(spec_file_path, spec_content(part_class_name))
        end

        private

        attr_reader :fs, :inflector

        def part_ruby_class_file(key:, namespace:, base_path:)
          Hanami::CLI::Generators::App::RubyClassFile.new(
            fs: fs,
            inflector: inflector,
            namespace: namespace,
            key: key,
            base_path: base_path,
            extra_namespace: "views/parts",
          )
        end

        def generate_base_part_specs(namespace:, base_path:, app_namespace:)
          if base_path != "spec"
            generate_base_part_spec_at(fs.join("spec", "views", "part_spec.rb"), app_namespace)

          end
          generate_base_part_spec_at(fs.join(base_path, "views", "part_spec.rb"), namespace)
        end

        def spec_content(class_name)
          # Extract the part name from the class name for the let variable
          part_name = class_name.split("::").last.downcase

          <<~RUBY
            # frozen_string_literal: true

            RSpec.describe #{class_name} do
              subject { described_class.new(value:) }
              let(:value) { double("#{part_name}") }

              it "works" do
                expect(subject).to be_kind_of(described_class)
              end
            end
          RUBY
        end

        def generate_base_part_spec_at(path, namespace)
          return if fs.exist?(path)

          fs.write(path, base_part_spec_content(namespace))
        end

        def base_part_spec_content(namespace)
          <<~RUBY
            # frozen_string_literal: true

            RSpec.describe #{namespace}::Views::Part do
              subject { described_class.new(value:) }
              let(:value) { double("value") }

              it "works" do
                expect(subject).to be_kind_of(described_class)
              end
            end
          RUBY
        end
      end
    end
  end
end
