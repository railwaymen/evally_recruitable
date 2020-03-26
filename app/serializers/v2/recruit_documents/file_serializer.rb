# frozen_string_literal: true

module V2
  module RecruitDocuments
    class FileSerializer < Blueprinter::Base
      identifier :id

      fields :content_type

      field :filename do |file|
        file.filename.to_s
      end

      field :kilobyte_size do |file|
        "#{(file.byte_size.to_f / 1.kilobyte).round(2)}kB"
      end

      field :path do |file|
        ActiveStorage::Current.set(host: 'http://localhost:3030') do
          file.service_url
        end
      end
    end
  end
end
