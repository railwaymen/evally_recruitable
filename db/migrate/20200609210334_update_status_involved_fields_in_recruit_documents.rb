class UpdateStatusInvolvedFieldsInRecruitDocuments < ActiveRecord::Migration[6.0]
  def change
    remove_column :recruit_documents, :decision_made_at, :datetime
    remove_column :recruit_documents, :recruit_accepted_at, :datetime

    add_column :recruit_documents, :incomplete_details, :text
  end
end
