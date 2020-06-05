class Topic < ApplicationRecord
    has_many :steps
    def get_steps
        self.steps.order(:order)
    end
end
