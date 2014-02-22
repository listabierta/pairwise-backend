class CreateMorePromptIndexes < ActiveRecord::Migration
  def self.up
    add_index :prompts, [:left_choice_id, :right_choice_id, :question_id], :name => "a_cool_index", :unique => true
  end

  def self.down
    remove_index :prompts, [:left_choice_id, :right_choice_id, :question_id]
  end
end
