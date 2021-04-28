class CreateJoinTableRecruitmentCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :recruitment_candidates, id: false do |t|
      t.bigint :recruitment_id, null: false
      t.bigint :recruit_document_id, null: false
      t.string :stage, null: false
      t.integer :position, null: false, default: 0
      t.integer :priority, null: false, default: 0

      t.index [:recruitment_id, :recruit_document_id], name: 'index_recruitment_recruit_document_on_ids'
      t.index [:recruit_document_id, :recruitment_id], name: 'index_recruit_document_recruitment_on_ids'
    end
  end
end
