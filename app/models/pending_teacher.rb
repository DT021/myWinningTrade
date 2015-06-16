# == Schema Information
#
# Table name: pending_teachers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :timestamp(6)     not null
#  updated_at :timestamp(6)     not null
#

class PendingTeacher < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user

  validates :user_id, uniqueness: true

  def self.upgrade_user_to_teacher(user_id)
    teacher = PendingTeacher.find_by_user_id(user_id)

    user = User.find(user_id)

    user.group = 'teacher'

    user.save

    teacher.destroy
  end
end
