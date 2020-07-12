class UserTopicItem < ApplicationRecord
    belongs_to :user

    SUBSCRIPTION_VALUES = {
        "none" => "None",
        "daily" => "Daily",
        "weekly" => "Weekly",
        "monthly" => "Monthly",
    }
    if Rails.env.development?
        SUBSCRIPTION_VALUES["constantly"] = "Constantly"
    end
    SUBSCRIPTION_VALUES.freeze

end
