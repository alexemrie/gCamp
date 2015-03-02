require 'rails_helper'

describe User do
  before :each do
    @user = User.create!(
    first_name: "Bill",
    last_name: "Smith",
    email: "billsmith@example.com",
    password: "password123",
    password_confirmation: "password123"
    )

    User.destroy_all
  end

  it "is valid with a first_name, last_name, email, password, and password_confirmation" do
    @user.valid?
    expect(@user).to be_valid
  end

  it "requires a first_name" do
     @user.first_name = ""
     @user.valid?
     expect(@user.errors[:first_name]).to include("can't be blank")
  end


  it "requires a last_name" do
    @user.last_name = ""
    @user.valid?
    expect(@user.errors[:last_name]).to include("can't be blank")
  end

  it "requires an email" do
   @user.email = ""
   @user.valid?
   expect(@user.errors[:email]).to include("can't be blank")
  end

  it "requires a unique email" do
    @user = User.create!(
    first_name: "Bill",
    last_name: "Smith",
    email: "billsmith@example.com",
    password: "password123",
    password_confirmation: "password123"
    )

    new_user = User.new(
    first_name: "Scott",
    last_name: "Smith",
    email: "billsmith@example.com",
    password: "123",
    password_confirmation: "123"
    )

    new_user.valid?

    expect(new_user.errors[:email]).to include("has already been taken")
  end

  it "requires a password" do
    new_user = User.new(
    first_name: "Alex",
    last_name: "Emrie",
    email: "billsmith@example.com",
    password: "",
    password_confirmation: ""
    )

    new_user.valid?

    expect(new_user.errors[:password]).to include("can't be blank")
  end

  it "requires a password confirmation" do
    new_user = User.new(
    first_name: "Alex",
    last_name: "Emrie",
    email: "billsmith@example.com",
    password: "123",
    password_confirmation: ""
    )

    new_user.valid?

    expect(new_user.errors[:password_confirmation]).to include("can't be blank")
  end

  it "requires a matching password / password_confirmation" do
    new_user = User.new(
    first_name: "Alex",
    last_name: "Emrie",
    email: "billsmith@example.com",
    password: "123",
    password_confirmation: "456"
    )

    new_user.valid?

    expect(new_user.errors[:password_confirmation]).to include("doesn't match Password")
  end
end
