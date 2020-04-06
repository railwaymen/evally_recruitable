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
        ActiveStorage::Current.set(host: 'http://localhost:3030') do
          file.service_url
        end
      end
    end
  end
end
