class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :username
      t.index :username
      t.string :password
      t.index :password
      t.string :email
      t.index :email

      t.timestamps
    end
    
  end
end
