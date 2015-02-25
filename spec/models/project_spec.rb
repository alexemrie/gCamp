require 'rails_helper'

describe Project do
  it "Creates a project without a name" do
    project = Project.create(name: "")
    expect(project).to be_invalid
  end
end
