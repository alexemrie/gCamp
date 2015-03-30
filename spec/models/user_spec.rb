require 'rails_helper'

describe User do
  let(:valid_attributes) {
    {
      first_name: "Bill",
      last_name: "Smith",
      email: "billsmith@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
  }

  it "is valid with a first_name, last_name, email, password, and password_confirmation" do
    user = User.new(valid_attributes)
    expect(user).to be_valid
  end

  it "requires a first_name" do
    valid_attributes[:first_name] = nil
    user = User.new(valid_attributes)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end


  it "requires a last_name" do
    valid_attributes[:last_name] = nil
    user = User.new(valid_attributes)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "requires an email" do
    valid_attributes[:email] = nil
    user = User.new(valid_attributes)
    user.valid?
   expect(user.errors[:email]).to include("can't be blank")
  end

  it "requires a unique email" do
    user_1 = User.create!(valid_attributes)
    user_2 = User.new(valid_attributes)
    user_2.valid?
    expect(user_2.errors[:email]).to include("has already been taken")
  end

  it "requires a password" do
    valid_attributes[:password] = nil
    user = User.new(valid_attributes)

    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "requires a matching password / password_confirmation" do
    valid_attributes[:password_confirmation] = "abc"
    user = User.new(valid_attributes)
    user.valid?
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end
end
