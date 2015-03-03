require 'rails_helper'

describe Project do
  let(:valid_attributes) {
    {
      name: "Write an article"
    }
  }

  it "is valid with a project name" do
    new_project = Project.new(valid_attributes)

    new_project.valid?
    expect(new_project).to be_valid
  end

  it "requires a project name" do
    valid_attributes[:name] = nil
    new_project = Project.new(valid_attributes)

    new_project.valid?
    expect(new_project.errors[:name]).to include("can't be blank")
  end
end
