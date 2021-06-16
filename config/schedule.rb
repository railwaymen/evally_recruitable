# frozen_string_literal: true

require "#{path}/config/environment"

set :output, 'log/cron.log'
set :environment, Rails.env

every :day, at: '6am' do
  rake 'group_classifier:train'
end
