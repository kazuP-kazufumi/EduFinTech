class AddCategoryToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :category, :string, default: 'その他'
  end
end
