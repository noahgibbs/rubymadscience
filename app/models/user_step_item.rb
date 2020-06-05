class UserStepItem < ApplicationRecord
    belongs_to :user
    belongs_to :step

    DONE_MAP = {
        0 => "Not Done",
        1 => "Skip",
        2 => "Done",
    }

    def self.done_values
        DONE_MAP.values
    end

    def self.done_as_text(int_value)
        DONE_MAP[int_value]
    end

    def done_as_text
        UserStepItem.done_as_text(self.doneness)
    end
end
