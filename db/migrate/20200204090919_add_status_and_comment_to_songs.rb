class AddStatusAndCommentToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :status, :integer, default: 1
    add_column :songs, :comment, :text
  end
end
