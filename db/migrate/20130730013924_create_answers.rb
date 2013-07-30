class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :name
      t.string :email
      t.references :ask, index: true

      t.timestamps
    end
  end
end
