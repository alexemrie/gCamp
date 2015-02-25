require 'rails_helper'

describe User do
  before :each do
    User.destroy_all
    @user = User.create(first_name: "Alex", last_name: "Emrie", email: "emrieaj@gmail.com")
  end

  it "requires a first_name" do
    @user.save
    expect(@user.first_name).to eql("Alex")
  end

  it "requires a last_name" do
    @user.save
    expect(@user.last_name).to eql("Emrie")
  end

  it "requires an email" do
    @user.save
    expect(@user.email).to eql("emrieaj@gmail.com")
  end

  it "requires a unique email" do
    user2 = User.create(first_name: "Grant", last_name: "Emrie", email: "emrieaj@gmail.com")
    expect(user2).to be_invalid
  end
end
