namespace :sync do
  namespace :core do
    desc 'Evally Core - synchronization'

    task recruits: :environment do
      admin = User.admin.first

      if admin.present?
        RecruitDocument.find_each.map do |recruit_document|
          V2::Sync::RecruitSyncService.new(recruit_document, admin).perform
        end
      else
        puts "\nAdmin account does not exist, please create one to run synchronization"
      end
    end

    task evaluator_changes: :environment do
      admin = User.admin.first

      if admin.present?
        Change.evaluator_context.find_each.map do |change|
          V2::Sync::EvaluatorChangeSyncService.new(change, admin).perform
        end
      else
        puts "\nAdmin account does not exist, please create one to run synchronization"
      end
    end

    task status_changes: :environment do
      admin = User.admin.first

      if admin.present?
        Change.status_context.find_each.map do |change|
          V2::Sync::StatusChangeSyncService.new(change, admin).perform
        end
      else
        puts "\nAdmin account does not exist, please create one to run synchronization"
      end
    end
  end
end
