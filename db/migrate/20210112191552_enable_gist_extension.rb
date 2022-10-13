class EnableGistExtension < ActiveRecord::Migration[5.2]
  def change
    enable_extension :btree_gist
  end
end
