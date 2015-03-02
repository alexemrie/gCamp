require 'rails_helper'

describe Task do
  it "is valid with a description and due_date" do
    new_task = Task.create(description: "Do stuff", due_date: "12/5/2015")

    expect(new_task).to be_valid
  end

  it "Creates a project without a description" do
    new_task = Task.create(description: "")

    new_task.valid?
    expect(new_task.errors[:description]).to include("can't be blank")
  end

  it "updates a task to be complete" do
    task = Task.create(description: "Do Homework", due_date: "12/5/2015", complete: false)
    task.update(complete: true)

    expect(task.complete).to eql true
  end
end
