# frozen_string_literal: true

module V2
  module RecruitDocuments
    class GroupsMonthlyChartQuery
      def initialize(base_date)
        @base_date = base_date
      end

      def call
        ActiveRecord::Base.connection.exec_query(raw_sql).to_a
      end

      private

      # rubocop:disable Metrics/MethodLength, Layout/LineLength
      def raw_sql
        "
          SELECT
            TO_CHAR(t0.day::date, 'YYYY-MM-DD') AS label,
            t1.*
          FROM
            GENERATE_SERIES(
              #{first_day_of_month},
              #{last_day_of_month},
              '1 day'::interval
            ) AS t0(day)
          LEFT JOIN LATERAL(
            SELECT DISTINCT ON (\"group\")
              \"group\",
              t2.group_count AS value
            FROM
              recruit_documents AS rd_groups
            LEFT JOIN LATERAL(
              SELECT
                COUNT(*) AS group_count
              FROM recruit_documents
              WHERE
                recruit_documents.group = rd_groups.group AND
                  TO_CHAR(t0.day::date, 'YYYY-MM-DD') = TO_CHAR(recruit_documents.received_at::date, 'YYYY-MM-DD')
            ) t2 ON true
          ) t1 ON true;
        "
      end
      # rubocop:enable Metrics/MethodLength, Layout/LineLength

      def first_day_of_month
        ActiveRecord::Base.sanitize_sql(
          ["DATE_TRUNC('month', ?::date)", @base_date]
        )
      end

      def last_day_of_month
        ActiveRecord::Base.sanitize_sql(
          ["DATE_TRUNC('month', ?::date) + '1 month - 1 day'::interval", @base_date]
        )
      end
    end
  end
end
