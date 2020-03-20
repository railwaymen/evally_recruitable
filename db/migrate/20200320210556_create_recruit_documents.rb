class CreateRecruitDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :recruit_documents do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :gender
      t.string :email, null:false
      t.string :phone
      t.string :status, null: false, default: 'received'
      t.string :position, null: false
      t.string :group, null: false, default: 'Unassigned'
      t.boolean :accept_current_processing, null: false, default: true
      t.boolean :accept_future_processing, null: false
      t.string :source
      t.datetime :received_at, null: false

      t.timestamps
    end
  end
end
