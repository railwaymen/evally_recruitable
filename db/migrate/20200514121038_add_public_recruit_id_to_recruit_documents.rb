class AddPublicRecruitIdToRecruitDocuments < ActiveRecord::Migration[6.0]
  def up
    add_column :recruit_documents, :public_recruit_id, :string, index: true
    add_index :recruit_documents, :public_recruit_id

    RecruitDocument.all.map(&:save!)

    change_column_null :recruit_documents, :public_recruit_id, false
  end

  def down
    remove_column :recruit_documents, :public_recruit_id
  end
end
