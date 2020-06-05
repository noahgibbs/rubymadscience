class UserStepItem < ApplicationRecord
    belongs_to :user
    belongs_to :step
end
