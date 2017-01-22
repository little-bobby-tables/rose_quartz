class AddTwoFactorAuthWithRoseQuartz < ActiveRecord::Migration[5.0]
  def up
    create_table :user_authenticators do |t|
      t.integer :user_id
      t.string  :secret
      t.integer :last_authenticated_at
    end
  end

  def down
    drop_table :user_authenticators
  end
end
