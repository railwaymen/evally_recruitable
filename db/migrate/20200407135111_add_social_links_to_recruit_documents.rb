class AddSocialLinksToRecruitDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :recruit_documents, :social_links, :jsonb, null: false, default: []
  end
end
