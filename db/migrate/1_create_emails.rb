class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.json 'mail'
      t.timestamps
    end
  end
end