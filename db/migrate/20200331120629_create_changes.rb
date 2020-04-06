class CreateChanges < ActiveRecord::Migration[6.0]
  def change
    create_table :changes do |t|
      t.string :context, null: false
      t.string :from
      t.string :to, null: false
      t.jsonb :details, default: {}
      t.references :changeable, polymorphic: true, null: false

      t.timestamps null: false
    end
  end
end
