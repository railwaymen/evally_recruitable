# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::Shared::ServerSideTableQuery do
  describe '.paginated_scope' do
    it 'expects to return 1 page with 2 records' do
      record_one, record_two = FactoryBot.create_list(:recruit_document, 2)
      FactoryBot.create(:recruit_document)

      params = {
        page: 1,
        per_page: 2
      }

      query = described_class.new(RecruitDocument.all, params: params)

      expect(query.paginated_scope).to contain_exactly record_one, record_two
    end
  end

  describe '.final_scope' do
    it 'expects to return full scope if no params' do
      record_one, record_two, record_three = FactoryBot.create_list(:recruit_document, 3)

      query = described_class.new(RecruitDocument.all, params: {})

      expect(query.final_scope).to contain_exactly record_one, record_two, record_three
    end

    it 'expects to return records filtering by position' do
      record_one = FactoryBot.create(
        :recruit_document,
        position: 'RoR Developer'
      )

      FactoryBot.create(
        :recruit_document,
        position: 'QA Engineer'
      )

      record_two = FactoryBot.create(
        :recruit_document,
        position: 'RoR Developer'
      )

      params = {
        filters: {
          position: 'RoR Developer'
        }
      }

      query = described_class.new(RecruitDocument.all, params: params)

      expect(query.final_scope).to contain_exactly record_one, record_two
    end

    it 'expects to return records filtering by multiple' do
      record_one = FactoryBot.create(
        :recruit_document,
        position: 'RoR Developer',
        group: 'Developers'
      )

      FactoryBot.create(
        :recruit_document,
        position: 'QA Engineer',
        group: 'QAs'
      )

      FactoryBot.create(
        :recruit_document,
        position: 'RoR Developer',
        group: 'Team Leads'
      )

      params = {
        filters: {
          position: 'RoR Developer',
          group: 'Developers'
        }
      }

      query = described_class.new(RecruitDocument.all, params: params)

      expect(query.final_scope).to contain_exactly record_one
    end

    it 'expects to return records ignoring unknown filter' do
      record_one = FactoryBot.create(
        :recruit_document,
        position: 'RoR Developer'
      )

      FactoryBot.create(
        :recruit_document,
        position: 'QA Engineer'
      )

      record_two = FactoryBot.create(
        :recruit_document,
        position: 'RoR Developer'
      )

      params = {
        filters: {
          position: 'RoR Developer',
          unknown_column: 'random value'
        }
      }

      query = described_class.new(RecruitDocument.all, params: params)

      expect(query.final_scope).to contain_exactly record_one, record_two
    end

    it 'expects to return records sorting asc by position' do
      record_one = FactoryBot.create(
        :recruit_document,
        position: 'A'
      )

      record_two = FactoryBot.create(
        :recruit_document,
        position: 'B'
      )

      params = {
        sort_by: 'position',
        sort_dir: 'asc'
      }

      query = described_class.new(RecruitDocument.all, params: params)

      expect(query.final_scope.to_a).to eq [record_one, record_two]
    end

    it 'expects to return records sorting desc by position' do
      record_one = FactoryBot.create(
        :recruit_document,
        position: 'A'
      )

      record_two = FactoryBot.create(
        :recruit_document,
        position: 'B'
      )

      params = {
        sort_by: 'position',
        sort_dir: 'desc'
      }

      query = described_class.new(RecruitDocument.all, params: params)

      expect(query.final_scope.to_a).to eq [record_two, record_one]
    end

    it 'expects to return records using search' do
      record_one = FactoryBot.create(
        :recruit_document,
        position: 'Junior Android Dev'
      )

      FactoryBot.create(
        :recruit_document,
        position: 'Marketing Specialist'
      )

      record_two = FactoryBot.create(
        :recruit_document,
        position: 'Senior Android Dev'
      )

      params = {
        search: 'android'
      }

      query = described_class.new(RecruitDocument.all, params: params)

      expect(query.final_scope).to contain_exactly record_one, record_two
    end

    it 'expect to return records without signature' do
      record_one = FactoryBot.create(
        :recruit_document,
        message: nil
      )

      FactoryBot.create(
        :recruit_document,
        message: 'abc'
      )

      record_two = FactoryBot.create(
        :recruit_document,
        message: nil
      )

      params = {
        filters: {
          message: nil
        }
      }

      query = described_class.new(RecruitDocument.all, params: params, require_values: false)

      expect(query.final_scope).to contain_exactly record_one, record_two
    end

    it 'expects to work with strong action controller parameters' do
      record_one = FactoryBot.create(
        :recruit_document,
        position: 'Junior Android Dev',
        group: 'Android',
        received_at: '2020-01-01'
      )

      FactoryBot.create(
        :recruit_document,
        position: 'Junior Marketing Specialist',
        group: 'Marketing',
        received_at: '2020-02-01'
      )

      FactoryBot.create(
        :recruit_document,
        position: 'Senior Android Dev',
        group: 'Android',
        received_at: '2019-01-01'
      )

      FactoryBot.create(
        :recruit_document,
        position: 'Senior Android Dev',
        group: 'Android',
        received_at: '2018-01-01'
      )

      params = ActionController::Parameters.new(
        page: 1,
        per_page: 2,
        search: 'junior',
        sort_by: 'received_at',
        sort_dir: 'desc',
        filters: { group: 'Android' }
      )

      query = described_class.new(RecruitDocument.all, params: params.permit!)

      expect(query.final_scope).to contain_exactly record_one
    end
  end
end
