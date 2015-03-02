require 'rails_helper'

describe Project do
  it "Creates a project without a name" do
    new_project = Project.create(name: "")

    new_project.valid?
    expect(new_project.errors[:name]).to include("can't be blank")
  end
end
