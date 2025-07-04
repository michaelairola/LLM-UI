class Message < ApplicationRecord
    enum :role, { system: 0, user: 1, assistant: 2 }
    belongs_to :chat
end
