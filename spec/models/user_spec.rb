require 'rails_helper'

describe User do
  before :each do
    User.destroy_all
  end

  it "requires a first_name" do
    user = User.create(first_name: "", last_name: "Smith", email: "billsmith@example.com")
    expect(user).to be_invalid
  end

  it "requires a last_name" do
    user = User.create(first_name: "Bill", last_name: "", email: "billsmith@example.com")
    expect(user).to be_invalid
  end

  it "requires an email" do
    user = User.create(first_name: "Bill", last_name: "Smith", email: "")
    expect(user).to be_invalid
  end

  it "requires a unique email" do
    user = User.create(first_name: "Bill", last_name: "Smith", email: "billsmith@example.com")
    user2 = User.create(first_name: "Grant", last_name: "Smith", email: "billsmith@example.com")
    expect(user2).to be_invalid
  end
end
