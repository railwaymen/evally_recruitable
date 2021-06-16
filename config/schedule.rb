# frozen_string_literal: true

require "#{path}/config/environment"

set :output, 'log/cron.log'
set :environment, Rails.env

every 1.hour do
  rake 'group_classifier:train'
end
