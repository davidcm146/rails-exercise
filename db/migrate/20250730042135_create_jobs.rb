class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.integer :status
      t.datetime :published_date
      t.string :share_link
      t.integer :salary_from
      t.integer :salary_to
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
