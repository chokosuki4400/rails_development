CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage    = :aws
    config.aws_bucket = ENV.fetch('AWS_S3_BUCKET')
    config.aws_acl    = 'public-read'

    # The maximum period for authenticated_urls is only 7 days.
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    # Set custom options such agit s cache control to leverage browser caching
    config.aws_attributes = {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    }

    # aws credential
    config.aws_credentials = {
      # 今回はIAM ロールを使用するため記載しない
      access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      region: ENV['AWS_REGION']
    }
  else
    # テスト時はローカルにファイルを保存する
    config.storage = :file
  end
end

# require 'carrierwave/storage/abstract'
# require 'carrierwave/storage/file'
# require 'carrierwave/storage/fog'
#
# CarrierWave.configure do |config|
#   if Rails.env.production?
#     config.storage :fog
#     config.fog_provider = 'fog/aws'
#     config.fog_directory  = ENV['AWS_S3_BUCKET']
#     config.fog_credentials = {
#       provider: 'AWS',
#       aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
#       aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
#       region: ENV['AWS_REGION'],
#       path_style: true
#     }
#   else
#     config.storage :file
#     config.enable_processing = false if Rails.env.test?
#   end
# end
# # 日本語の文字化けを防ぐ
# CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
#
#
# # CarrierWave.configure do |config|
# #   if Rails.env.production?
# #     config.storage :fog
# #     config.fog_provider = 'fog/aws'
# #     config.fog_directory  = 'バケット名'
# #     config.fog_credentials = {
# #       provider: 'AWS',
# #       aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
# #       aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
# #       region: ENV['AWS_REGION'],
# #       path_style: true
# #     }
# #   else
# #     config.storage :file
# #     config.enable_processing = false if Rails.env.test?
# #   end
# # end
# #
# # CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/