class User < ActiveRecord::Base
  has_secure_password

  validates :password, :presence => true

  validates :password_confirmation, :presence => true, :confirmation => true

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true, :uniqueness => true

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships

  has_many :comments, dependent: :nullify

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin_or_member?(project)
    self.admin ||= self.memberships.find_by(project_id: project.id) != nil
  end

  def admin_or_owner?(project)
    self.admin || self.memberships.find_by(project_id: project.id) != nil && self.memberships.find_by(project_id: project.id).role == 'Owner'
  end

  def match_user_projects(user)
    (self.memberships.pluck(:project_id) & user.memberships.pluck(:project_id)).any?
  end

  def hide_token(token)
    if token
      number_of_asterisks = '*'* (token.length - 4)
      token[0..3] + number_of_asterisks
    end
  end
end
