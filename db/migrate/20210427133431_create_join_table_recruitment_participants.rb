class CreateJoinTableRecruitmentParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :recruitment_participants do |t|
      t.bigint :recruitment_id, null: false
      t.bigint :user_id, null: false

      t.index [:recruitment_id, :user_id]
      t.index [:user_id, :recruitment_id]
    end
  end
end
