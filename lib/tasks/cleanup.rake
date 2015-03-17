namespace :cleanup do

  desc 'Removes all memberships where their users have already been deleted'
  task remove_orphans: :environment do
    Membership.where.not(user_id: User.pluck(:id)).delete_all
  end

  desc 'Removes all memberships where their projects have already been deleted'
  task remove_orphans: :environment do
    Membership.where.not(project_id: Project.pluck(:id)).delete_all
  end

  desc 'Removes all comments where their tasks have been deleted'
  task remove_orphans: :environment do
    Comment.where.not(task_id: Task.pluck(:id)).delete_all
  end

  desc 'Removes all tasks where their projects have been deleted'
  task remove_orphans: :environment do
    Task.where.not(project_id: Project.pluck(:id)).delete_all
  end

  desc 'Sets the user_id of comments to nil if their users have been deleted'
  task remove_orphans: :environment do
    Comment.where.not(user_id: User.pluck(:id)).update_all(user_id: nil)
  end

  desc 'Removes all memberships with a null user_id'
  task remove_orphans: :environment do
    Membership.where(user_id: nil).destroy_all
  end

  desc 'Removes all memberships with a null project_id'
  task remove_orphans: :environment do
    Membership.where(project_id: nil).destroy_all
  end

  desc 'Removes any tasks with null project_id'
  task remove_orphans: :environment do
    Task.where(project_id: nil).destroy_all
  end

  desc 'Removes any comments with a null task_id'
  task remove_orpans: :environment do
    Comment.where(task_id: nil).destroy_all
  end

  desc "Deletes any memberships with a null project_id"
  task remove_orphans: :environment do
    Membership.where(project_id: nil).destroy_all
  end
end
