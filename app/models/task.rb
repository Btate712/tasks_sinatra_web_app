class Task < ActiveRecord::Base
  belongs_to :creator, class_name: "User", foreign_key: 'creator_id'
  belongs_to :owner, class_name: "User", foreign_key: 'owner_id'
  has_many :notes

  validates :short_description, presence: true
  validates :owner_id, presence: true

end
