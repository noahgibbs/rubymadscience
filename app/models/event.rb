class Event < ApplicationRecord
  belongs_to :user, optional: true
end
