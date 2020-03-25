class AddStatusRelatedFieldsToRecruitDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :recruit_documents, :task_sent_at, :datetime
    add_column :recruit_documents, :call_scheduled_at, :datetime
    add_column :recruit_documents, :interview_scheduled_at, :datetime
    add_column :recruit_documents, :decision_made_at, :datetime
    add_column :recruit_documents, :recruit_accepted_at, :datetime
    add_column :recruit_documents, :rejection_reason, :text
  end
end
