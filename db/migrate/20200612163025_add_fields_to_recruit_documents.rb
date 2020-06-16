class AddFieldsToRecruitDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :recruit_documents, :salary, :string
    add_column :recruit_documents, :availability, :string
    add_column :recruit_documents, :available_since, :date
    add_column :recruit_documents, :contract_type, :string
    add_column :recruit_documents, :work_type, :string
    add_column :recruit_documents, :location, :string
    add_column :recruit_documents, :message, :text
  end
end
