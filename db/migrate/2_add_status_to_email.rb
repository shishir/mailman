class AddStatusToEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :status, :string
  end
end