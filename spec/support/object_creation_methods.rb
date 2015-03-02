def create_user(options={})
  @current_user = User.create!({
    first_name: "Crazy",
    last_name: "John",
    email: "crazyjohn@example.com",
    password: "password123",
    password_confirmation: "password123"
  }.merge(options))
end

def create_project(options={})
  Project.create!({
    name: "Do Stuff"
  }.merge(options))
end

def create_task(options={})
  Task.create!({
    description: "Take out the Dog",
    due_date: "12/31/2015"
  }.merge(options))
end
