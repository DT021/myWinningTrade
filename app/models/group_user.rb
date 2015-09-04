# == Schema Information
#
# Table name: group_users
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :timestamp(6)     not null
#  updated_at :timestamp(6)     not null
#

class GroupUser < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to :group

  belongs_to :user
end