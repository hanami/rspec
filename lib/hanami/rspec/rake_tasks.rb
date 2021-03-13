# frozen_string_literal: true

require "hanami/rake_tasks"

Hanami::RakeTasks.register_tasks do
  require "rspec/core/rake_task"
  ::RSpec::Core::RakeTask.new(:spec)

  task default: :spec
end
