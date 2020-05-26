# frozen_string_literal: true

module V2
  module Attachments
    class Serializer < Blueprinter::Base
      identifier :id

      fields :content_type

      field :name do |file|
        file.filename.to_s
      end

      field :size do |file|
        "#{(file.byte_size.to_f / 1.kilobyte).round(2)}kB"
      end

      field :url do |file|
        active_storage_host = Rails.application.config.env.fetch(:recruitable).fetch(:host)

        ActiveStorage::Current.set(host: active_storage_host) do
          file.service_url
        end
      end
    end
  end
end
