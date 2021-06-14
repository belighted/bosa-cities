# Monkey patch to prevent DB tasks to be run automatically in test environment when
# run in development environment (see https://github.com/rails/rails/issues/27299) .
# This code should be updated with each Rails update
if ENV.fetch("DISABLE_RAILS_AUTORUN_TEST_DB_TASK", 0).to_i == 1
  module ActiveRecord
    module Tasks
      module DatabaseTasks

        private

        def each_current_configuration(environment)
          environments = [environment]

          ActiveRecord::Base.configurations.slice(*environments).each do |configuration_environment, configuration|
            next unless configuration["database"]

            yield configuration, configuration_environment
          end
        end
      end
    end
  end
end
