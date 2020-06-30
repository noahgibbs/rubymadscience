class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  # Note that neither Topic nor Step is an ActiveRecord model.
  # Step isn't even a Ruby object, just a name.
  has_many :user_step_items
  has_many :user_topic_items
end
