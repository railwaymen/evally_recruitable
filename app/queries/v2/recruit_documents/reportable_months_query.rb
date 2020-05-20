# frozen_string_literal: true

module V2
  module RecruitDocuments
    class ReportableMonthsQuery
      def self.call
        ActiveRecord::Base.connection.exec_query(raw_sql).to_a
      end

      def self.raw_sql # rubocop:disable Metrics/MethodLength
        "
          SELECT DISTINCT
            TO_CHAR(
              GENERATE_SERIES(t0.first_month::date, t0.latest_month::date, '1 month'::interval),
              'YYYY-MM-DD'
            ) AS month
          FROM (
            SELECT
              DATE_TRUNC('month', FIRST_VALUE(received_at) OVER (ORDER BY received_at ASC))
                AS first_month,
              DATE_TRUNC('month', FIRST_VALUE(received_at) OVER (ORDER BY received_at DESC))
                AS latest_month
            FROM recruit_documents
          ) t0
          ORDER BY month DESC;
        "
      end

      private_class_method :raw_sql
    end
  end
end
