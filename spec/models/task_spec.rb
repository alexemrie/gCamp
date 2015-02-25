require 'rails_helper'

describe Task do
  it "Creates a project without a description" do
    task = Task.create(description: "")
    expect(task).to be_invalid
  end
end
