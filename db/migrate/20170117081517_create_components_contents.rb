class CreateComponentsContents < ActiveRecord::Migration[5.0]
  def change
    create_table :components_contents, :id => false do |t|
      t.belongs_to :content, index: true
      t.belongs_to :component, index: true
    end
  end
end
