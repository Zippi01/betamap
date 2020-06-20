class AddCommentToParserSite < ActiveRecord::Migration[6.0]
  def change
    add_column :parser_sites, :comment, :string
  end
end
