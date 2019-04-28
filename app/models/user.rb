class User < ActiveRecord::Base
  has_many :subordinates, class_name: "User", foreign_key: "manager_id"
  has_many :owned_tasks, class_name: "Task", foreign_key: "owner_id"
  has_many :created_tasks, class_name: "Task", foreign_key: "creator_id"
  has_many :notes, through: :tasks
  belongs_to :manager, class_name: "User"
end
