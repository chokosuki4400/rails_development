# frozen_string_literal: true

module MessagesHelper
  require 'sendgrid-ruby'
  include SendGrid

  class << self

    def send(address, username, hash, url)
      from = SendGrid::Email.new(email: ENV['FROM_ADDRESS'])
      to = SendGrid::Email.new(email: address)
      subject = username + 'さん、あなたに質問が届きました！'
      hoge = address

      # ヒアドキュメント内で変数を使う場合、
      # #{x}で囲む
      str = <<-EOS
      あなたに質問が届きました！

      質問を確認する：#{url}/#{hash}
      EOS

      content = SendGrid::Content.new(type: 'text/plain', value: str)
      mail = SendGrid::Mail.new(from, subject, to, content)

      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)
      Rails.logger.debug(response.status_code)
    end

  end
end
