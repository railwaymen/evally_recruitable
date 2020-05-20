# frozen_string_literal: true

module V2
  module RecruitDocuments
    class GroupsYearlyChartQuery
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
              #{first_month_of_year},
              #{last_month_of_year},
              '1 month'::interval
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
                  TO_CHAR(t0.day::date, 'YYYY-MM') = TO_CHAR(recruit_documents.received_at::date, 'YYYY-MM')
            ) t2 ON true
          ) t1 ON true;
        "
      end
      # rubocop:enable Metrics/MethodLength, Layout/LineLength

      def first_month_of_year
        ActiveRecord::Base.sanitize_sql(
          ["DATE_TRUNC('year', ?::date)", @base_date]
        )
      end

      def last_month_of_year
        ActiveRecord::Base.sanitize_sql(
          ["DATE_TRUNC('year', ?::date) + '1 year - 1 month'::interval", @base_date]
        )
      end
    end
  end
end
