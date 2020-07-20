class AddUserTokenToChanges < ActiveRecord::Migration[6.0]
  def up
    add_column :changes, :user_token, :string
    add_index :changes, :user_token

    user = User.recruiter.first || User.admin.first
    Change.update_all(user_token: user.email_token)
  end

  def down
    remove_column :changes, :user_token
  end
end
