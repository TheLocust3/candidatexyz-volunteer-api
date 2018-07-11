class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string 'identifier', null: false
      t.string 'url', null: false

      t.timestamps
    end
  end
end
