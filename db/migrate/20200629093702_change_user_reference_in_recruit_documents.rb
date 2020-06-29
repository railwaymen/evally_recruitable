class ChangeUserReferenceInRecruitDocuments < ActiveRecord::Migration[6.0]
  def up
    add_column :recruit_documents, :evaluator_token, :string

    RecruitDocument.all.map do |recruit_document|
      next if recruit_document.evaluator_id.blank?

      user = User.find_by(id: recruit_document.evaluator_id)
      recruit_document.update(evaluator_token: user&.email_token)
    end

    remove_column :recruit_documents, :evaluator_id
  end

  def down
    add_column :recruit_documents, :evaluator_id, :integer

    User.all.map do |user|
      recruit_documents = RecruitDocument.find_by(evaluator_token: user.email_token)

      recruit_documents.update_all(evaluator_id: user.id)
    end

    remove_column :recruit_documents, :evaluator_token
  end
end
