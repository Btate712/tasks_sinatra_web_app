class User < ActiveRecord::Base
  has_many :subordinates, class_name: "User", foreign_key: "supervisor_id"
  has_many :owned_tasks, class_name: "Task", foreign_key: "owner_id"
  has_many :created_tasks, class_name: "Task", foreign_key: "creator_id"
  has_many :notes
  belongs_to :supervisor, class_name: "User"
  has_secure_password

  def slug
    self.username.downcase.split(" ").join("-")
  end

  def can_assign_to?(other_user)
    #check to see if other_user is a subordinate
    self.subordinates.include?(other_user) || self == other_user ||
      self.subordinates.any? { |user| user.can_assign_to?(other_user) }
  end

  def is_administrator?
    self.administrator
  end
  
  def self.find_by_slug(slug)
    self.all.find { |user| user.slug == slug }
  end
end
