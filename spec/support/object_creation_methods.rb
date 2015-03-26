def create_user(options={})
  User.create!({
    first_name: "Crazy",
    last_name: "John",
    email: "crazyjohn#{rand(100000) + 1}@example.com",
    password: "password123",
    password_confirmation: "password123",
    admin: true
  }.merge(options))
end

def create_project(options = {})
  defaults = {
    name: "Do Stuff"
  }
  project = Project.create!(defaults.merge(options))
end

def create_task(options={})
  Task.create!({
    description: "Take out the Dog",
    project_id: create_project.id,
    due_date: "12/31/2015"
  }.merge(options))
end

def create_comment(options={})
  Comment.create!({
    description: "Nice Job!",
    user_id: create_user.id,
    task_id: create_task.id
    }.merge(options))
end

def create_membership(options={})
  Membership.create!({
    role: "Member",
    project_id: create_project.id,
    user_id: create_user.id
  }.merge(options))
end
