class Userinfo < ApplicationRecord
  belongs_to :user, inverse_of: :userinfo, optional: true
  mount_uploader :image, ImageUploader
end
