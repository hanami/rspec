# frozen_string_literal: true

require "hanami/cli/generators/app/ruby_class_file"

module Hanami
  module RSpec
    module Generators
      # @since 2.0.0
      # @api private
      class Action
        # @since 2.0.0
        # @api private
        def initialize(fs:, inflector:)
          @fs = fs
          @inflector = inflector
        end

        # @since 2.0.0
        # @api private
        def call(key:, namespace:, base_path:)
          ruby_class_file = action_ruby_class_file(key: key, namespace: namespace, base_path: base_path)
          spec_file_path = ruby_class_file.path.gsub(/\.rb$/, "_spec.rb")
          action_class_name = ruby_class_file.fully_qualified_name

          fs.write(spec_file_path, spec_content(action_class_name))
        end

        private

        attr_reader :fs, :inflector

        def action_ruby_class_file(key:, namespace:, base_path:)
          Hanami::CLI::Generators::App::RubyClassFile.new(
            fs: fs,
            inflector: inflector,
            namespace: namespace,
            key: inflector.underscore(key),
            base_path: base_path,
            extra_namespace: "Actions",
          )
        end

        def spec_content(class_name)
          <<~RUBY
            # frozen_string_literal: true

            RSpec.describe #{class_name} do
              let(:params) { Hash[] }

              it "works" do
                response = subject.call(params)
                expect(response).to be_successful
              end
            end
          RUBY
        end
      end
    end
  end
end
