class Membership < ActiveRecord::Base
  ROLE = ["Member", "Owner"]
  validates_presence_of :user
  validates_uniqueness_of :user, scope: :project, message: "has already been added to this project"


  belongs_to :user
  belongs_to :project
end
