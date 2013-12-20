class CreateShowTimes < ActiveRecord::Migration
  def change
    create_table :show_times do |t|
      t.integer :cinema_id
      t.integer :movie_id
      t.datetime :showing_at

      t.timestamps
    end
  end
end
