# frozen_string_literal: true

module ApplicationHelper
  require "uri"

  def text_url_to_link text

    URI.extract(text, ['http','https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, sub_text)
    end

    return text
  end

  def default_meta_tags
    {
      site: 'モノフィ-Monofy-',
      title: '',
      reverse: true,
      charset: 'utf-8',
      description: 'モノフィは、人から褒められてテンションを上がることができるサービスです。',
      keywords: 'モノフィ,テンション,嬉しい',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon.ico') },
        # { href: image_url('icon.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: 'モノフィ-Monofy-',
        title: 'モノフィ-Monofy-',
        description: 'モノフィは、人から褒められてテンションを上がることができるサービスです。',
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@bakyun_net',
      }
    }
  end
end