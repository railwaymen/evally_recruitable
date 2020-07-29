# frozen_string_literal: true

set :rails_env, :staging
set :deploy_to, ENV['CAP_STAGING_DEPLOY_TO']
server ENV['CAP_STAGING_SERVER'], user: ENV['CAP_STAGING_SSH_USER'], roles: %w[app db web]
set :rvm_ruby_version, 'ruby-2.7.0'
set :branch, :develop

append :linked_files, 'config/credentials/staging.key'

namespace :deploy do
  after :publishing, :restart do
    on roles :web do
      execute 'systemctl --user restart sidekiq'
    end
  end
end
