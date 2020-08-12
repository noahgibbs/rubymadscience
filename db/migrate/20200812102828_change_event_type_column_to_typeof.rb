class ChangeEventTypeColumnToTypeof < ActiveRecord::Migration[6.0]
  def change
    rename_column :events, :type, :typeof
  end
end
