class Note < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  validates :content, presence: true

end
