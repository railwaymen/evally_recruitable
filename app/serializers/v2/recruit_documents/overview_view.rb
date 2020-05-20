# frozen_string_literal: true

module V2
  module RecruitDocuments
    class OverviewView < Blueprinter::Base
      fields :months, :groups, :groups_monthly_chart_data, :groups_yearly_chart_data,
             :sources, :sources_monthly_chart_data, :sources_yearly_chart_data
    end
  end
end
