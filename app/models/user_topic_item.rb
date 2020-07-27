class UserTopicItem < ApplicationRecord
    belongs_to :user

    SUBSCRIPTION_VALUES = {
        "none" => "None",
        "daily" => "Daily",
        "weekly" => "Weekly",
        "monthly" => "Monthly",
    }
    SUBSCRIPTION_VALUES.freeze

end
