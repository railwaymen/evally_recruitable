class AddEvaluatorIdToRecruitDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :recruit_documents, :evaluator_id, :integer
  end
end
