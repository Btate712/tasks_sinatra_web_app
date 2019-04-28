class User < ActiveRecord::Base
  has_many :subordinates, class_name: "User", foreign_key: "manager_id"
  has_many :owned_tasks, class_name: "Task", foreign_key: "owner_id"
  has_many :created_tasks, class_name: "Task", foreign_key: "creator_id"
  has_many :notes
  belongs_to :manager, class_name: "User"
  has_secure_password

  # User instances cannot be saved without a password attribute being assinged

  def slug
    self.username.downcase.split(" ").join("-")
  end

  def self.find_by_slug(slug)
    self.all.find { |user| user.slug == slug }
  end
end
