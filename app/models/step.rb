class Step < ApplicationRecord
    belongs_to :topic
    has_many :user_step_items
end
