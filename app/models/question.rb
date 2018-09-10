class Question < ApplicationRecord
  belongs_to :user, inverse_of: :question, optional: true
  has_one :question, dependent: :destroy, inverse_of: :user
end
