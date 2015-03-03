require 'rails_helper'

describe Task do
  let(:valid_attributes) {
    {
      description: "Take out the Dog",
      due_date: "12/31/2015",
      complete: true
    }
  }

  it "is valid with a description and due_date" do
    new_task = Task.new(valid_attributes)
    expect(new_task).to be_valid
  end

  it "requires a description" do
    valid_attributes[:description] = nil
    new_task = Task.new(valid_attributes)
    new_task.valid?
    expect(new_task.errors[:description]).to include("can't be blank")
  end
end
