class CreateRecruitments < ActiveRecord::Migration[6.0]
  def change
    create_table :recruitments do |t|
      t.string :name, null: false
      t.text :description
      t.jsonb :stages, null: false, default: []
      t.string :status, null: false, default: 'draft'
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
