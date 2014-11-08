class CreateLicentaEventTrails < ActiveRecord::Migration
  def change
    create_table :licenta_event_trails do |t|
      t.string :transaction_id
      t.string :target_type
      t.string :action
      t.string :result
      t.string :payload
      t.string :method

      t.timestamps
    end
  end
end
