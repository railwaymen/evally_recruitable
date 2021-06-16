namespace :group_classifier do
  desc 'Tasks for group classification training'

  task train: :environment do
    RecruitDocuments::GroupClassifierService.new.train
  end
end
