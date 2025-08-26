# frozen_string_literal: true

module Hanami
  module RSpec
    module Generators
      # @since 2.0.0
      # @api private
      class Slice
        # @since 2.0.0
        # @api private
        def initialize(fs:, inflector:)
          @fs = fs
          @inflector = inflector
        end

        # @since 2.0.0
        # @api private
        def call(slice)
          camelized_slice_name = inflector.camelize(slice)

          fs.write("spec/slices/#{slice}/action_spec.rb", action_spec_content(camelized_slice_name))
          fs.touch("spec/slices/#{slice}/actions/.keep")

          # fs.write("spec/slices/#{slice}/view_spec.rb", t("view_spec.erb", context))
          # fs.write("spec/slices/#{slice}/repository_spec.rb", t("repository_spec.erb", context))
          # fs.write("spec/slices/#{slice}/views/.keep", t("keep.erb", context))
          # fs.write("spec/slices/#{slice}/templates/.keep", t("keep.erb", context))
          # fs.write("spec/slices/#{slice}/templates/layouts/.keep", t("keep.erb", context))
          # fs.write("spec/slices/#{slice}/entities/.keep", t("keep.erb", context))
          # fs.write("spec/slices/#{slice}/repositories/.keep", t("keep.erb", context))
        end

        private

        attr_reader :fs, :inflector

        def action_spec_content(camelized_slice_name)
          <<~RUBY
            # frozen_string_literal: true

            RSpec.describe #{camelized_slice_name}::Action do
              xit "works"
            end
          RUBY
        end
      end
    end
  end
end
