class Question < ApplicationRecord
  belongs_to :user, inverse_of: :question, optional: true
  has_one :answers, dependent: :destroy, inverse_of: :user
end
