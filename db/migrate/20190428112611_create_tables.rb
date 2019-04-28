class CreateTables < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.string :content
      t.integer :task_id
      t.integer :user_id
    end

    create_table :tasks do |t|
      t.string :short_description
      t.string :long_description
      t.integer :creator_id
      t.integer :owner_id
      t.date :due_date
      t.boolean :completed
    end

    create_table :users do |t|
      t.string :password_digest
      t.string :username
      t.string :email
      t.integer :manager_id
      t.string :name
    end
  end
end
