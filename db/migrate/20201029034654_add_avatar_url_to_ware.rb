class AddAvatarUrlToWare < ActiveRecord::Migration[5.2]
  def change
    add_column :wares, :avatar, :string
  end
end
