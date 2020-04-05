class AddMessageIdToRecruitDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :recruit_documents, :message_id, :string
  end
end
