class Question < ApplicationRecord
  belongs_to :user, inverse_of: :question, optional: true
end
