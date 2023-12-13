# frozen_string_literal: true

class ChangeEndToFinishInEvents < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :end, :finish
  end
end
