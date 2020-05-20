# frozen_string_literal: true

module V2
  module RecruitDocuments
    class OverviewPresenter
      DATE_PARSER = lambda do |date|
        Date.strptime(date.to_s, '%Y-%m-%d')
      rescue Date::Error
        Date.current
      end

      def initialize(base_date = '')
        @base_date = DATE_PARSER.call(base_date).to_s
      end

      def groups
        RecruitDocument.distinct(:group).order(:group).pluck(:group)
      end

      def groups_monthly_chart_data
        V2::RecruitDocuments::GroupsMonthlyChartQuery.new(@base_date).call
      end

      def groups_yearly_chart_data
        V2::RecruitDocuments::GroupsYearlyChartQuery.new(@base_date).call
      end

      def sources
        RecruitDocument.distinct(:source).order(:source).pluck(:source)
      end

      def sources_monthly_chart_data
        V2::RecruitDocuments::SourcesMonthlyChartQuery.new(@base_date).call
      end

      def sources_yearly_chart_data
        V2::RecruitDocuments::SourcesYearlyChartQuery.new(@base_date).call
      end

      def months
        V2::RecruitDocuments::ReportableMonthsQuery.call
      end
    end
  end
end
