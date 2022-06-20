# frozen_string_literal: true

require "hanami/cli/rake_tasks"

Hanami::CLI::RakeTasks.register_tasks do
  require "rspec/core/rake_task"
  ::RSpec::Core::RakeTask.new(:spec)

  task default: :spec
end
