class Userinfo < ApplicationRecord
  belongs_to :user, inverse_of: :userinfo, optional: true
end
