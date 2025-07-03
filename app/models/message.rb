class Message < ApplicationRecord
    enum role: [:system, :user, :assistant]
end
