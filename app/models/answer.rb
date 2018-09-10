class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :question, optional: true
end
