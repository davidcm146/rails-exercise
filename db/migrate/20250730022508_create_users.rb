class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :full_name
      t.string :password_digest

      t.timestamps
    end
  end
end
