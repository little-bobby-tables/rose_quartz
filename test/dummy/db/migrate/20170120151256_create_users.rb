class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.timestamps
    end

    create_table :user_authenticators do |t|
      t.integer :user_id
      t.string  :secret
      t.integer :last_authenticated_at
    end
  end
end
