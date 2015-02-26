require 'rails_helper'

describe Task do
  it "Creates a project without a description" do
    task = Task.create(description: "")
    expect(task).to be_invalid
  end

  it "Marks a task as complete" do
    task = Task.create(description: "Do Homework", due_date: "12/5/2015", complete: false)
    task.update(complete: true)
    
    expect(task.complete).to eql true
  end
end
